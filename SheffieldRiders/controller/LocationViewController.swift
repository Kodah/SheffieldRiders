//
//  LocationViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 28/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var location = Dictionary<String, NSObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.title = location["name"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "locationDetailCollectionSegue"){
                
                let viewController = segue.destinationViewController as! LocationInfoCollectionViewController
                
                viewController.location = self.location
                
                
            }
        }
        
    }

}
