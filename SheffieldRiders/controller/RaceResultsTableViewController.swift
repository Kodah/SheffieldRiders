//
//  RaceResultsTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 04/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreData

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
        
    }
    
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
