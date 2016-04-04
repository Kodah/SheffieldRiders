//
//  UpcomingRacesTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 04/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import DATAStack
import CoreData
import SwiftSpinner

class UpcomingRacesTableViewController: UITableViewController {

    
    var races: [Race]?
    var selectedRace: Race?
    var formatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Syncing Races")
        
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle

        
        DataSynchroniser.sharedInstance.syncRaces { 
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let dataStack:DATAStack = appDelegate.dataStack
            let request = NSFetchRequest(entityName: "Race")
            self.races = try! dataStack.mainContext.executeFetchRequest(request) as! [Race]
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = races?.count {
            return count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let race = races![indexPath.row]
        
        cell.textLabel!.text = race.title
        
        cell.detailTextLabel?.text = formatter.stringFromDate(race.date!)
       
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRace = races![indexPath.row]
        performSegueWithIdentifier("raceSegueIdentifier", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "raceSegueIdentifier"){
                
                let viewController = segue.destinationViewController as! RaceTableViewController
                viewController.race = selectedRace
            }
        }
    }

}
