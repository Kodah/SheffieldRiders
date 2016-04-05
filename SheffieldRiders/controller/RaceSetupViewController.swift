//
//  RaceSetupViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 03/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import SwiftSpinner


class RaceSetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, LeaderBoardTableViewControllerDelegate {
    
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var racersTextView: UITextView!
    
    
    var locations = [String]()
    var locationIndex = 0
    var racers = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = loadJsonNames()
        
        let navButton = UIBarButtonItem(title: "Create race", style: .Done, target: self, action: #selector(uploadNewRaceButtonTapped))
        
        navigationItem.rightBarButtonItem = navButton
        
    }
    
    func didAddRaceParticipant(username: String) {
        racers.insert(username)
        racersTextView.text = ""
        for racer in racers
        {
            let racerString = "\(racer) \n"
            racersTextView.text = racersTextView.text.stringByAppendingString(racerString)
        }
    }
    
    func uploadNewRaceButtonTapped()
    {
        SwiftSpinner.show("Creating Race")
        
        let location: String = locations[locationIndex]
        let date = Int(datepicker.date.timeIntervalSince1970)
        var racersDic = [[String: String]]()
        
        for racerName in racers {
            racersDic.append(["name" : racerName])
        }
        
        
        let raceInfo: [String: AnyObject] = ["title" : titleTextfield.text!,
                                         "location" : location,
                    "date" : date,
                    "racers" : racersDic]
        
        DataSynchroniser.sharedInstance.uploadRace(raceInfo) { 
            SwiftSpinner.show("Event Created")
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                SwiftSpinner.hide()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func addRacer(sender: AnyObject) {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeaderboardViewController") as! LeaderBoardTableViewController
        let navController = UINavigationController(rootViewController: viewController)
        
        viewController.fromRaceBuilder = true
        viewController.delegate = self
        
        
        presentViewController(navController, animated: true, completion: nil)
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationIndex = row
        titleTextfield.resignFirstResponder()
    }
    
    func loadJsonNames() -> [String]{
        var locationNames = [String]()
        if let path = NSBundle.mainBundle().pathForResource("locations", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                do
                {
                    let locations =  try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [Dictionary<String, NSObject>]
                    
                    
                    
                    for location in locations {
                        
                        if let name = location["name"] as? String {
                            locationNames.append(name)
                        }
                    }
                    
                }
                catch
                {
                    print("error")
                }
            }
        }
        return locationNames
    }
}
