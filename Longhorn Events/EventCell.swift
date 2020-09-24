//
//  EventCell.swift
//  Longhorn Events
//
//  Created by Aditya Kuppa on 9/1/20.
//  Copyright © 2020 Aditya Kuppa. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    func setOption(event: Event) {
        eventTitleLabel.text = event.name
    }
   

}
