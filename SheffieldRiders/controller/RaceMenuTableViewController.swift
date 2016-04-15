//
//  RaceMenuTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 05/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class RaceMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Race Menu"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "pastEventsSegue") {
            let viewController = segue.destinationViewController as! RacesTableViewController
            
            viewController.pastEvents = true
        } else if (segue.identifier == "upcomingEventsSegue") {
            let viewController = segue.destinationViewController as! RacesTableViewController
            
            viewController.pastEvents = false
        }
    }

}
