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
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        racers = try! dataStack!.mainContext.executeFetchRequest(request) as! [Racer]
        
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        if let _ = racer.startDate {
            cell.startTime.text = "Started!"
            cell.backgroundColor = UIColor.greenColor()
            cell.stopButton.enabled = true
            cell.stopButton.backgroundColor = UIColor.redColor()
        } else {
            cell.startTime.text = "Not Started"
            cell.stopButton.enabled = false
            cell.stopButton.backgroundColor = UIColor.lightGrayColor()
        }
        if let _ = racer.finishDate {
            cell.finishTimeLabel.text = "Finished!"
            cell.stopButton.backgroundColor = UIColor.greenColor()
        } else {
            cell.finishTimeLabel.text = "Not Finished"
        }
        
        if let _ = racer.startDate, _ = racer.finishDate {
            cell.startTime.enabled = false
            cell.stopButton.enabled = false
            cell.startButton.backgroundColor = UIColor.lightGrayColor()
            cell.stopButton.backgroundColor = UIColor.lightGrayColor()
            cell.totalTimeLabel.text = racer.raceTimeString()
            cell.totalTimeLabel.backgroundColor = UIColor.greenColor()
        } else {
            cell.totalTimeLabel.text = "Pending"
            cell.backgroundColor = UIColor.orangeColor()
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
                viewController.race = race
            }
        }
        
    }

}
