//
//  DetailViewController.swift
//  Longhorn Events
//
//  Created by Aditya Kuppa on 9/1/20.
//  Copyright © 2020 Aditya Kuppa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var descp: UILabel!
    
    var event = Event(name: "", startsAt: Date(), link: "")
    
    func setEvent(event: Event) {
        self.event = event
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Scraper().updateInfo(event: event)
        eventTitle.text = event.name
        descp.text = event.getInfo()
    }
    
    


}
