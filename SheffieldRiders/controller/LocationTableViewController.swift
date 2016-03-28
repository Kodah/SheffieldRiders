//
//  LocationTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 28/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreData

class LocationTableViewController: UITableViewController {
    
    var locations = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Location")

        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            locations = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }



}
