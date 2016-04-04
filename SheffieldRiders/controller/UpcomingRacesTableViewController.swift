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

class UpcomingRacesTableViewController: UITableViewController {

    
    var races: [Race]?
    var selectedRace: Race?
    var formatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "Race")
        races = try! dataStack.mainContext.executeFetchRequest(request) as! [Race]
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (races?.count)!
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
