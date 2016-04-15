//
//  LocationViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 28/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftSpinner

class LocationViewController: UIViewController, LocationInfoCollectionViewDelegate, CLLocationManagerDelegate {
    
    var location = Dictionary<String, NSObject>()
    var locationManager: CLLocationManager = CLLocationManager()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0;
        locationManager.delegate = self

        if let image = UIImage(named: location["imageName"] as! String) {
            imageView.image = image
        }
        
        navigationItem.title = location["name"] as? String
        
        let checkinBarButton = UIBarButtonItem(title: "Check in", style: .Plain, target: self, action: #selector(self.attemptCheckin))
        navigationItem.rightBarButtonItem = checkinBarButton
    }


    func didChangeCollectionViewPage(page: Int) {
        pageControl.currentPage = page
    }
    
    func attemptCheckin()
    {
        SwiftSpinner.show("Checking location")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        self.locationManager.stopUpdatingLocation()
        
        
        let latitude = location["latitude"] as? CLLocationDegrees
        let longitude = location["longitude"] as? CLLocationDegrees
        let trackLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        
        let metersFromLocation = newLocation.distanceFromLocation(trackLocation)
        
        var atLocation = false
        if let area = location["area"] as? Int {
            
            if (metersFromLocation <= Double(area) * 1000)
            {
                atLocation = true
            }
        }
        SwiftSpinner.hide
        {
            if (atLocation) {
                SwiftSpinner.show("Nice Your Here at \(self.location["name"]!)", animated: false)
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    SwiftSpinner.show("Remember to respect the trails!", animated: false).addTapHandler({ 
                        SwiftSpinner.show("Increasing rep...", animated: true)
                        
                        let locationInfo = ["locationName" : self.location["name"]!]
                        
                        DataSynchroniser.sharedInstance.checkIn(locationInfo, callBack: {
                            SwiftSpinner.hide()
                        })
                    })
                }
            }
            else {
                SwiftSpinner.show("You're not at \(self.location["name"]!)", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "locationDetailCollectionSegue"){
                
                let viewController = segue.destinationViewController as! LocationInfoCollectionViewController
                
                viewController.delegate = self;
                viewController.location = self.location
                
                
            }
        }
        
    }

}
