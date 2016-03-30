//
//  LocationViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 28/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, LocationInfoCollectionViewDelegate {
    
    var location = Dictionary<String, NSObject>()

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.title = location["name"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func didChangeCollectionViewPage(page: Int) {
        pageControl.currentPage = page
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
