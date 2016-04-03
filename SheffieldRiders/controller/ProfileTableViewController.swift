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

protocol ProfileTableViewControllerDelegate {
    func reloadData(spots:[Spot])
}

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
    
    var delegate: ProfileTableViewControllerDelegate?
    var userProfile : UserProfile?
    var spotsVisited: [Spot]?
    var usernameForProfile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        if (usernameForProfile == nil) {
            navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showMenu), name: "showMenu", object: nil)

        }
        NSNotificationCenter.defaultCenter().addObserverForName("userProfileUpdated", object: nil, queue: nil) { _ in
            self.fetchProfile()
            self.updateUI()
            self.refreshControl?.endRefreshing()
        }
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        print(usernameForProfile)
        
        fetchProfile()
        updateUI()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "UserProfile")
        let profileResults:[UserProfile] = try! dataStack.mainContext.executeFetchRequest(request) as! [UserProfile]
        
        for profile in profileResults {
            print("Users - ", profile.username)
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fetchProfile(){
        if (usernameForProfile != nil) {
            fetchProfileWith(usernameForProfile!)
        }
        else
        {
            let loggedInUserName = NSUserDefaults.standardUserDefaults().objectForKey(Constants.LoggedInUser) as? String
            if let loggedInUserName = loggedInUserName {
                fetchProfileWith(loggedInUserName)
            }
        }
        
    }
    
    func fetchProfileWith(username: String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "UserProfile")
        request.predicate = NSPredicate(format: "username == %@", username)
        request.fetchLimit = 1
        let profileResults:[UserProfile] = try! dataStack.mainContext.executeFetchRequest(request) as! [UserProfile]
        
        userProfile = profileResults.first
        
        if let userProfile = userProfile {
            let requestSpots = NSFetchRequest(entityName: "Spot")
            requestSpots.predicate = NSPredicate(format: "userProfile = %@", userProfile)
            spotsVisited = (try! dataStack.mainContext.executeFetchRequest(requestSpots)) as? [Spot]
            
        }
    }
    
    func updateUI() {
        
        usernameLabel.text = userProfile?.username
        quoteLabel.text = userProfile?.quote
        disciplineLabel.text = userProfile?.discipline
        riderRepLabel.text = "\(userProfile?.rep!)"
        if let spotsVisited = spotsVisited {
            delegate?.reloadData(spotsVisited)
        }
    }
    
    func refresh()
    {
        DataSynchroniser.sharedInstance.syncProfile(nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "spotsVisitedSegue"){
                
                let viewController = segue.destinationViewController as! ProfileLocationsCollectionViewController
                delegate = viewController
                
            }
        }
    }
}
