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
    
    var locationsArray = [Dictionary<String, NSObject>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Locations"
        
        navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu", name: "showMenu", object: nil)
        
        loadJson()

        
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locationsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! LocationTableViewCell
        
        let location = locationsArray[indexPath.row]
        
        cell.titleLabel.text = location["name"] as? String
        cell.disciplineLabel.text = location["discipline"] as? String
        
        
        return cell
    }

    func loadJson(){
        
        if let path = NSBundle.mainBundle().pathForResource("locations", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                do
                {
                    locationsArray =  try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [Dictionary<String, NSObject>]
                    
                }
                catch
                {
                    print("error")
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "showLocation"){
                
                let viewController = segue.destinationViewController as! NewsViewController
                
                viewController.newsArticle = newsArray[selectedArticle]
                
                
            }
        }
        
    }

}
