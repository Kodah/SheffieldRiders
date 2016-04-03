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

class LeaderBoardTableViewController: UITableViewController,NSFetchedResultsControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var searchText = String()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        
        let usersFetchRequest = NSFetchRequest(entityName: "User")
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
        
        navigationItem.title = "Leaderboard"
        
        navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsTableViewController.showMenu), name: "showMenu", object: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
    }
    
    func showMenu() {
        tableView.setContentOffset(CGPointMake(0.0, -tableView.contentInset.top), animated:true)
        DropDownMenu.sharedInstance.showMenu(self.view)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText.characters.count > 0 {
            let filter = NSPredicate(format: "username CONTAINS[c] %@", searchText)
            fetchedResultsController.fetchRequest.predicate = filter
        }
        else {
            fetchedResultsController.fetchRequest.predicate = nil
        }

        
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
        
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
        let user = fetchedResultsController.objectAtIndexPath(indexPath) as! User
        
        if let username = user.username, rep = user.rep {
            cell.textLabel?.text = "\(username)"
            cell.detailTextLabel?.text = "\(rep)"
        }

        
        return cell
    }
 
}
