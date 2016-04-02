//
//  LocationViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 28/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, LocationInfoCollectionViewDelegate, CLLocationManagerDelegate {
    
    var location = Dictionary<String, NSObject>()
    var locationManager: CLLocationManager = CLLocationManager()

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0;
        locationManager.delegate = self

        navigationItem.title = location["name"] as? String
        
        let checkinBarButton = UIBarButtonItem(title: "Check in", style: .Plain, target: self, action: #selector(self.attemptCheckin))
        navigationItem.rightBarButtonItem = checkinBarButton
    }


    func didChangeCollectionViewPage(page: Int) {
        pageControl.currentPage = page
    }
    
    func attemptCheckin()
    {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        self.locationManager.stopUpdatingLocation()
        
        
        let latitude = location["latitude"] as? CLLocationDegrees
        let longitude = location["longitude"] as? CLLocationDegrees
        let trackLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        
        let metersFromLocation = newLocation.distanceFromLocation(trackLocation)
        
        if let area = location["arena"] as? Int {
            
            if (metersFromLocation == Double(area) * 1000)
            {
                
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
