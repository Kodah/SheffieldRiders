//
//  DataSynchroniser.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 02/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CoreData
import DATAStack
import Sync
import Alamofire
import SwiftSpinner

class DataSynchroniser: NSObject {
    
    static let sharedInstance = DataSynchroniser()
    
    func synchroniseAll() {
        self.syncAllUsers {
            NSNotificationCenter.defaultCenter().postNotificationName("didSyncAllNotification", object: nil)
        }
    }
    
    func syncAllUsers(callBack : (() -> Void)?)
    {
        print("Sync users - Started")
        
        Alamofire.request(.GET, Constants.apiBaseURL + "userprofile").responseJSON { response in
            let data = response.result.value as! [[String : AnyObject]]
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let dataStack:DATAStack = appDelegate.dataStack
            
            Sync.changes(data, inEntityNamed: "UserProfile", dataStack: dataStack , completion: { (error) in
                
                print("Sync users - finished")
                NSNotificationCenter.defaultCenter().postNotificationName("usersUpdated", object: self)
                
                if let callBack = callBack {
                    
                    callBack()
                }
            })
        }
    }
    
    func syncProfile(callBack : (() -> Void)?) {
        
        print("Sync userprofile - Started")
        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
            
            Alamofire.request(.GET, Constants.apiBaseURL + "userprofile/owner/", headers: ["Authorization":"bearer \(retrievedString)" ]).responseJSON { response in
                let data = response.result.value as! [String : AnyObject]
                
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let dataStack:DATAStack = appDelegate.dataStack
                
                Sync.changes([data], inEntityNamed: "UserProfile", dataStack: dataStack , completion: { (error) in
                    
                    print("Sync userprofile - finished")
                    NSNotificationCenter.defaultCenter().postNotificationName("userProfileUpdated", object: self)
                    
                    if let callBack = callBack {
                        
                        callBack()
                    }
                    
                })
            }
        }
    }
}
