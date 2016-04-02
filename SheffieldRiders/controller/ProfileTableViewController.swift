//
//  ProfileTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 24/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import Gloss
import SwiftKeychainWrapper
import CoreData
import DATAStack


class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var headerCell: UITableViewCell!
    @IBOutlet weak var locationVisitedCell: UITableViewCell!
    @IBOutlet weak var statisticsCell: UITableViewCell!
    @IBOutlet weak var rideCell: UITableViewCell!
    @IBOutlet weak var locationVisitedView: UIView!
    @IBOutlet weak var stackview: UIStackView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var riderRepLabel: UILabel!
    
//    var userProfile : UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
                
        navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showMenu), name: "showMenu", object: nil)

//        DataSynchroniser.sharedInstance.synchroniseAll()
//        DataSynchroniser.sharedInstance.syncProfile()
//        DataSynchroniser.sharedInstance.syncUsers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshUI), name: "userProfileUpdated", object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshUI(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        
        let request = NSFetchRequest(entityName: "UserProfile")
        let userProfile:[UserProfile] = try! dataStack.mainContext.executeFetchRequest(request) as! [UserProfile]
        
        
        let requestSpots = NSFetchRequest(entityName: "Spot")
        requestSpots.predicate = NSPredicate(format: "userProfile = %@", userProfile.first!)
        let spotsVisited:[Spot] = (try! dataStack.mainContext.executeFetchRequest(requestSpots)) as! [Spot]
        
       
        
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
