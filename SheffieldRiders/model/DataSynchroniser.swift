//
//  DataSynchroniser.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 02/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class DataSynchroniser: NSObject {
    
    static let sharedInstance = DataSynchroniser()
    
    var userProfile :UserProfile?
    
    
    func synchroniseAll() {
        
    }
    
    func syncProfile() {
        
        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
            
            let request = NSMutableURLRequest(URL: NSURL(string: Constants.apiBaseURL + "userprofile/owner/")!)
            request.HTTPMethod = "GET"
            request.addValue("bearer \(retrievedString)", forHTTPHeaderField: "Authorization")
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, error in
                guard data != nil else {
                    print("No response data")
                    return
                }
                
                do {
                    let response = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    print(response)
                    
                    guard let profile = UserProfile(json: response as! [String : AnyObject]) else
                    {
                        print("Issue deserializing model")
                        
                        return
                    }
                    
                    self.userProfile = profile
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("userProfileUpdated", object: self)
                    
                } catch {
                    
                }
            }
            
            task.resume()
        }
        
    }
    
}
