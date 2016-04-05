//
//  EventTypeTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 05/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class EventTypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Event Type"

        
        navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showMenu), name: "showMenu", object: nil)
    }

    func showMenu() {
       
        DropDownMenu.sharedInstance.showMenu(self.view)
    }


}
