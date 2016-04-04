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
    var dataStack:DATAStack?
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let finishRaceBarButton = UIBarButtonItem(title: "Finish", style: .Done, target: self, action: #selector(finishRace))
        navigationItem.rightBarButtonItem = finishRaceBarButton
        navigationItem.title = "Race"
        
        
    }
    
    func finishRace(){
        performSegueWithIdentifier("raceResultsSegue", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }

    func fetchData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        dataStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "Racer")
        request.predicate = NSPredicate(format: "race == %@", race!)
        racers = try! dataStack!.mainContext.executeFetchRequest(request) as! [Racer]
        
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

        cell.startButton.tag = indexPath.row
        cell.stopButton.tag = indexPath.row
        
        cell.startButton.addTarget(self, action: #selector(self.startButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        cell.stopButton.addTarget(self, action: #selector(self.stopButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        let racer = racers![indexPath.row]
        
        cell.nameLabel.text = racer.name
        
        if let startDate = racer.startDate {
            cell.startTime.text = startDate.stringValue
        } else {
            cell.startTime.text = "Not started"
        }
        if let finishDate = racer.finishDate {
            cell.finishTimeLabel.text = finishDate.stringValue
        } else {
            cell.finishTimeLabel.text = "Not finished"
        }
        
        if let _ = racer.startDate, _ = racer.finishDate {

            cell.totalTimeLabel.text = racer.raceTimeString()
        } else {
            cell.totalTimeLabel.text = "pending"
        }

        return cell
    }
    
    func startButtonPressed(button:UIButton) {
        
        let racer: Racer = racers![button.tag]
        
        racer.startDate = NSDate().timeIntervalSince1970
        
        do {
            try dataStack?.mainContext.save()
        } catch {
            print("core data error")
        }
        fetchData()
        tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: button.tag, inSection: 0)], withRowAnimation: .Automatic)
        syncData(racer)
    }
    
    func stopButtonPressed(button:UIButton) {
        
        let racer: Racer = racers![button.tag]
        
        racer.finishDate = NSDate().timeIntervalSince1970
        
        do {
            try dataStack?.mainContext.save()
        } catch {
            print("core data error")
        }
        fetchData()
        tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: button.tag, inSection: 0)], withRowAnimation: .Automatic)
        syncData(racer)
    }

    func syncData(racer: Racer) {
        // data sync upload
        DataSynchroniser.sharedInstance.updateRace(racer, callBack: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "raceResultsSegue"){
                
                let viewController = segue.destinationViewController as! RaceResultsTableViewController
                
                viewController.racers = racers
            }
        }
        
    }

}
