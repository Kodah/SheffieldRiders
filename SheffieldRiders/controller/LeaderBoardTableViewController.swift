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

class LeaderBoardTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        
        let usersFetchRequest = NSFetchRequest(entityName: "User")
        let primarySortDescriptor = NSSortDescriptor(key: "riderRep", ascending: true)
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

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
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
        let user = fetchedResultsController.objectAtIndexPath(indexPath) as! User
        
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = "\(user.riderRep!)"
        
        return cell
    }
 
}
