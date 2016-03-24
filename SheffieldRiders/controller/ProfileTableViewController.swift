//
//  ProfileTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 24/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        navigationItem.rightBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu", name: "showMenu", object: nil)
        
    }
    
    func showMenu() {
        DropDownMenu.sharedInstance.showMenu(self.view)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


    

}
