//
//  NewsTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 23/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "News"
        
        navigationItem.rightBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu", name: "showMenu", object: nil)
        
    }
    
    func showMenu() {
        DropDownMenu.sharedInstance.showMenu(self.view)
    }
}
