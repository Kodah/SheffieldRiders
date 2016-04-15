//
//  LeaderBoardTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 03/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreData
import DATAStack

protocol LeaderBoardTableViewControllerDelegate {
    func didAddRaceParticipant(username: String)
}



class LeaderBoardTableViewController: UITableViewController,NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchText = String()
    var selectedUsername: String?
    var fromRaceBuilder: Bool?
    var selectedUsernames: [String]?
    var delegate: LeaderBoardTableViewControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        
        let usersFetchRequest = NSFetchRequest(entityName: "UserProfile")
        let primarySortDescriptor = NSSortDescriptor(key: "rep", ascending: false)
        
            
        usersFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: usersFetchRequest,
            managedObjectContext: dataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (fromRaceBuilder != nil) {
            if selectedUsernames?.count > 0 {
                fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "NOT (username IN %@)", selectedUsernames!)
            }
            navigationItem.title = "Choose Racer"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneAddingUsers))
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsTableViewController.showMenu), name: "showMenu", object: nil)
        } else {
            navigationItem.title = "Leaderboard"
            navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsTableViewController.showMenu), name: "showMenu", object: nil)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("usersUpdated", object: nil, queue: nil) { _ in
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } catch {
                print("Fetch failed")
            }
        }
        refreshControl!.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
    }
    
    func doneAddingUsers(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refresh()
    {
        DataSynchroniser.sharedInstance.syncUsers(nil)
    }
    
    func showMenu() {

        DropDownMenu.sharedInstance.showMenu(self.view)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText.characters.count > 0 {
            if selectedUsernames?.count > 0 {
                fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "NOT (username IN %@) AND username CONTAINS[c] %@", selectedUsernames!, searchText)
            } else {
                fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "username CONTAINS[c] %@", searchText)
            }
        }
        else {
            if selectedUsernames?.count > 0 {
                fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "NOT (username IN %@)", selectedUsernames!)
            } else {
                fetchedResultsController.fetchRequest.predicate = nil
            }
            
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
        
        
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let user = fetchedResultsController.objectAtIndexPath(indexPath) as! UserProfile
        
        if let username = user.username, rep = user.rep {
            cell.textLabel?.text = "\(username)"
            cell.detailTextLabel?.text = "\(rep)"
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            let selectedUser: UserProfile = fetchedObjects[indexPath.row] as! UserProfile
            selectedUsername = selectedUser.username
            
            if (fromRaceBuilder != nil) {
                delegate?.didAddRaceParticipant(selectedUsername!)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                performSegueWithIdentifier("ShowUserProfileSegue", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "ShowUserProfileSegue"){
                
                let viewController = segue.destinationViewController as! ProfileTableViewController
                viewController.usernameForProfile = selectedUsername
            }
        }
    }
}
