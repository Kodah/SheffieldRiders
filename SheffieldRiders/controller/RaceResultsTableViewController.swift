//
//  RaceResultsTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 04/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreData
import SwiftSpinner

class RaceResultsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    var racers: [Racer]?
    {
        didSet {
            racers!.sortInPlace({$0.raceTime() < $1.raceTime()})
        }
    }
    var race: Race?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endBarButton = UIBarButtonItem(title: "End", style: .Done, target: self, action: #selector(end))
        navigationItem.rightBarButtonItem = endBarButton
        
        
        if racers?.count > 0 {
            let winner =  racers![0]
            winnerLabel.text = winner.name
        }
        if racers?.count > 1 {
            let secondPlace =  racers![1]
            secondLabel.text = secondPlace.name
        }
        if racers?.count > 2 {
            let thirdPlace =  racers![2]
            thirdLabel.text = thirdPlace.name
        }
    }
    
    func end()
    {
        SwiftSpinner.show("Awarding racers")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.awardRacesRaced()
        }
        
        
    }
    func awardPoints()
    {
        
    }
    
    func awardRacesRaced() {
        var eligibleRiders = [String]()
        if let racers = racers {
            for racer in racers {
                if ((racer.startDate) != nil) {
                    eligibleRiders.append(racer.name!)
                }
            }
        }
        
        let raceID: String = race!.remoteID!
        
        let body: [String: AnyObject] =
            [
                "raceID" : raceID,
                "racers" : eligibleRiders
            ]
        
        DataSynchroniser.sharedInstance.awardRacesRaced(body) {
            SwiftSpinner.show("Awarding Medalists")
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.awardMedalists()
            }
            
        }
    }
    
    func awardMedalists() {
        var body = [String:AnyObject]()
        var medalists = [[String:AnyObject]]()
        
        if let racers = racers {
            for (index, racer) in racers.enumerate() {
                if ((racer.startDate) != nil &&
                    (racer.finishDate) != nil &&
                    medalists.count < 4) {
                    medalists.append(["username" : racer.name!,
                        "result" : index + 1])
                }
            }
        }
        let id = race!.remoteID! as String
        body.add(["raceID" : id])
        body.add(["medalists": medalists])
        
        DataSynchroniser.sharedInstance.awardMedalists(body) {
            SwiftSpinner.hide()
        }
        
    }
    
//    {
//    "raceID": "57033321bb69f6a1bac9f3ee",
//    "medalists":[
//    {
//    "username" : "tom",
//    "result" : 1
//    },
//    {
//    "username" : "ste",
//    "result" : 1
//    }
//    ]
//    }
   
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return racers!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let racer = racers![indexPath.row]
        
        cell.textLabel?.text = "\(indexPath.row + 1)) \(racer.name!)"
        
        cell.detailTextLabel?.text = racer.raceTimeString()
        
        return cell
    }
    
}
