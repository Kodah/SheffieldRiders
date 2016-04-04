//
//  RaceTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 04/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreData
import DATAStack

class RaceTableViewController: UITableViewController {

    var race: Race?
    var racers: [Racer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "Racer")
        request.predicate = NSPredicate(format: "race == %@", race!)
        racers = try! dataStack.mainContext.executeFetchRequest(request) as! [Racer]

    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (racers?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RaceTableViewCell

        let racer = racers![indexPath.row]
        
        cell.nameLabel.text = racer.name

        return cell
    }
    



}
