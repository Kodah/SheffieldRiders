//
//  ProfileTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 24/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var headerCell: UITableViewCell!
    @IBOutlet weak var locationVisitedCell: UITableViewCell!
    @IBOutlet weak var statisticsCell: UITableViewCell!
    @IBOutlet weak var rideCell: UITableViewCell!
    @IBOutlet weak var locationVisitedView: UIView!
    @IBOutlet weak var stackview: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu", name: "showMenu", object: nil)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return headerCell.frame.height
        case 1: return stackview.frame.height
        case 2: return statisticsCell.frame.height
        case 3: return rideCell.frame.height
        default: return 200
        }
    }
    
    func showMenu() {
        
        tableView.setContentOffset(CGPointMake(0.0, -tableView.contentInset.top), animated:true)
        
        DropDownMenu.sharedInstance.showMenu(self.view)
    }


    

}
