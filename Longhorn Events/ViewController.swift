//
//  ViewController.swift
//  Longhorn Events
//
//  Created by Aditya Kuppa on 2/16/20.
//  Copyright © 2020 Aditya Kuppa. All rights reserved.
//

import UIKit
import SwiftSoup
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventList = [Event]()
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventList = Scraper().getEvents()
        eventTableView.delegate = self
        eventTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        let title = eventList[indexPath.row]
        cell.setOption(event: title)
           
        return cell
    }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dvc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        dvc?.setEvent(event: eventList[indexPath.row])
        self.navigationController?.pushViewController(dvc!, animated: true)
         
        // self.performSegue(withIdentifier: "segue", sender: nil)
    }
   
}


