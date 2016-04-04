//
//  RaceSetupViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 03/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class RaceSetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var racersTextView: UITextView!
    
    var locations = [String]()
    var locationIndex = 0
    let racers = ["ste", "tom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = loadJsonNames()
        
        let navButton = UIBarButtonItem(title: "Create race", style: .Done, target: self, action: #selector(uploadNewRace))
        
        navigationItem.rightBarButtonItem = navButton
        
        racersTextView.text = ""
        for racer in racers
        {
            let racerString = "\(racer) \n"
            racersTextView.text = racersTextView.text.stringByAppendingString(racerString)
        }
        
    }
    
    func uploadNewRace()
    {
        var dick: [String: AnyObject] = ["title" : titleTextfield.text!,
                                         "location" : locations[locationIndex],
                    "date" : datepicker.date,
                    "racers" : racers]
                
        print(dick)
    }
    
    @IBAction func addRacer(sender: AnyObject) {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeaderboardViewController")
        let navController = UINavigationController(rootViewController: viewController)
        
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
