//
//  NewsTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 23/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var newsArray = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "News"
        
        navigationItem.rightBarButtonItem = DropDownMenu.sharedInstance.menuButton
        
        loadJson()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu", name: "showMenu", object: nil)
        
    }
    
    func showMenu() {
        DropDownMenu.sharedInstance.showMenu(self.view)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! NewsTableViewCell
        
        let article = newsArray[indexPath.row]
        
        cell.newsTitle.text = article["title"]
        cell.newsBody.text = article["body"]
        if let image = UIImage(named: article["image"]!) {
            cell.newsImage.image = image
        }

        
        return cell
    }
    
    func loadJson(){
        
        if let path = NSBundle.mainBundle().pathForResource("news", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                do
                {
                    newsArray =  try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [Dictionary<String, String>]
                    
                }
                catch
                {
                    print("error")
                }
            }
        }
    }
    
    
    
    
}
