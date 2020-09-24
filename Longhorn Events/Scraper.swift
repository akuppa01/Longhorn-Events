//
//  Scraper.swift
//  Longhorn Events
//
//  Created by Aditya Kuppa on 8/31/20.
//  Copyright © 2020 Aditya Kuppa. All rights reserved.
//

import Foundation
import SwiftSoup


class Scraper {
    
    let csEventsLink = "https://www.cs.utexas.edu/events"
    
    var events = [Event]()
    
    //gets the HTML code for the link and returns it in a Document
    func getHTMLDoc(link: String) throws -> Document {
        //---------> fix the error handling system in this function
        guard let myURL = URL(string: link)
            else { print("Link not working"); throw NetworkError.linkMalfunction }
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        let doc: Document = try SwiftSoup.parse(html)
        return doc
    }
    
    
    func updateInfo(event: Event) {
        do {
            let subDoc: Document = try getHTMLDoc(link: event.link)
            try updateInfoHelper(event: event, doc: subDoc)
        } catch {
            print("No site/description info found")
        }
    }
    
    func updateInfoHelper(event: Event, doc: Document) throws {
        let pageHTML = try doc.select("article")
        let fields = try pageHTML.select("div.field-items").array()

        event.person = try fields[0].text()
        event.email = try fields[1].text()
        event.endsAt = getEndDate(text: try fields[2].text())
        event.location = try fields[3].text()
        event.categories = try fields[4].text().components(separatedBy: " ")
        let descpCode = fields[5]
        let linesCode = try descpCode.select("p").array()
        var descp = ""
        for lnc in linesCode{
            descp += try lnc.text() + "\n\n"
        }
        print(descp)
        event.descp = descp
    }
    
    func getEvents() -> [Event] {
        do {
            let subDoc: Document = try getHTMLDoc(link: csEventsLink)
            try getEventsHelper(doc: subDoc)
        } catch {
            print("No site/events info found")
        }
        return events
    }
    
    func getEventsHelper(doc: Document) throws {
        let pageHTML = try doc.select("[class=view-content]")
        let bodyHTML = try pageHTML.select("[class=field-content]")
        
        var currEventTitle = ""
        var currEventLink = ""
        var currEventDate = Date()
        
        for item in bodyHTML {
            let text : String = try item.text()
            
            if !isDate(line: text){
                currEventTitle = text
                currEventLink = try item.select("a").first()!.attr("href")
            } else {
                currEventDate = getDate(text: text)
                let event = Event(name: currEventTitle, startsAt: currEventDate, link: currEventLink)
                events.append(event)
                print(event)
            }
        }
    }
    
    func isDate(line: String) -> Bool {
        let daysOfWeek: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let words = line.components(separatedBy: [" ", ",", "-"])

        if daysOfWeek.contains(words[0]) {
            return true
        }
        return false
    }
    
    func getDate(text: String) -> Date {
        let arr = text.components(separatedBy: [","," ","-"])
        let monthsInYear : [String:String] = ["January":"01", "February":"02", "March":"03", "April":"04", "May":"05", "June":"06", "July":"07", "August":"08", "September":"09", "October":"10", "November":"11", "December":"12"]
        let dateStr = "\(monthsInYear[arr[2]]!)/\(arr[3])/\(arr[5]) \(arr[8])"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
        dateFormatter.timeZone = TimeZone(abbreviation: "CDT")
        let date = dateFormatter.date(from: dateStr)
        //let msg = dateFormatter.string(from: date ?? Date())

        return date ?? Date()
    }
    
    func getEndDate(text: String) -> Date {
        
        let arr = text.components(separatedBy: [","," ","-"])
        let dateStr = "\(arr[2]) \(arr[7])"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
        dateFormatter.timeZone = TimeZone(abbreviation: "CDT")
        let date = dateFormatter.date(from: dateStr)
        //let msg = dateFormatter.string(from: date ?? Date())

        return date ?? Date()
    }
}

class Event : CustomStringConvertible {
    var name : String
    var startsAt : Date
    var link : String
    var endsAt = Date()
    var location = ""
    var person = ""
    var email = ""
    var categories = [String]()
    var descp = ""
    
    init(name : String, startsAt : Date, link : String) {
        self.name = name
        self.startsAt = startsAt
        self.link = link
    }
    
    var description : String {
        return "\(name)\n\(startsAt)\n\(link)\n"
    }
    
    func getInfo() -> String {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "HH:mma E, d MMM y"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
         
        var result = ""
        result.append("Event: \(name)\n")
        result.append("Name: \(person)\n")
        result.append("Email: \(email)\n")
        result.append("Location: \(location)\n")
        result.append("Starts at: \(dateFormatter.string(from: startsAt))\n")
        result.append("Ends at: \(dateFormatter.string(from: endsAt))\n")
        result.append("Categories: \(categories)\n")
        result.append("Description: \(descp)\n")
        print(result)
        return result
    }
    
}

//stores different types of errors pertaining to the app
enum NetworkError: Error {
    case linkMalfunction
}
