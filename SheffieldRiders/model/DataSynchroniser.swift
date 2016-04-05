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
        self.syncUsers {
            self.syncRaces {
                NSNotificationCenter.defaultCenter().postNotificationName("didSyncAllNotification", object: nil)
            }
        }
    }
    
    func syncUsers(callBack : (() -> Void)?)
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
    
    func syncRaces(callBack : (() -> Void)?){
        print("Sync races - Started")
        
        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
            
            Alamofire.request(.GET, Constants.apiBaseURL + "race", headers: ["Authorization":"bearer \(retrievedString)" ]).responseJSON { response in
                let data = response.result.value as! [[String : AnyObject]]
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let dataStack:DATAStack = appDelegate.dataStack
                
                Sync.changes(data, inEntityNamed: "Race", dataStack: dataStack , completion: { (error) in
                    
                    print("Sync races - finished")
                    NSNotificationCenter.defaultCenter().postNotificationName("racesUpdated", object: self)
                                        
                    if let callBack = callBack {
                        
                        callBack()
                    }
                })
            }
        }
    }
    
    func uploadRace(raceInfo: [String: AnyObject], callBack : (() -> Void)?) {
        print("Uploading race - Started")
        
        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
            
            Alamofire.request(.POST, Constants.apiBaseURL + "race", parameters: raceInfo, encoding: .JSON, headers: ["Authorization":"bearer \(retrievedString)" ]).responseJSON(completionHandler: { JSON in
                print(JSON)
                if let callBack = callBack {
                    
                    print("Uploading race - Finished")
                    
                    callBack()
                }
            })
        }
    }
    
    func updateRace(racer: Racer, callBack : (() -> Void)?){
        print("Sync races - Started")
        
        let url = NSURL.init(string: Constants.apiBaseURL + "race")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var json: [String : AnyObject] = ["remoteID" : racer.remoteID!]
        if let startDate = racer.startDate{
            json.add(["startDate" : startDate])
        }
        if let finishDate = racer.finishDate{
            json.add(["finishDate" : finishDate])
        }
        
        print(json)
        
        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
            
            Alamofire.request(.PUT, Constants.apiBaseURL + "race", parameters: json, encoding: .JSON, headers: ["Authorization":"bearer \(retrievedString)" ]).responseJSON(completionHandler: { JSON in
                print(JSON)
            })
        }
    }
    
    func awardRacesRaced(body: [String: AnyObject], callBack : (() -> Void)?) {
        print("Uploading Points - Started")
        
        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
                                                            
            Alamofire.request(.PUT, Constants.apiBaseURL + "userprofile/racesraced", parameters: body, encoding: .JSON, headers: ["Authorization":"bearer \(retrievedString)" ]).responseJSON(completionHandler: { JSON in
                print(JSON)
                if let callBack = callBack {
                    
                    print("Uploading points - Finished")
                    
                    callBack()
                }
            })
        }
    }
    
    func awardMedalists(body: [String: AnyObject], callBack : (() -> Void)?) {
        print("Uploading Medalist Points - Started")

        if let retrievedString: String = KeychainWrapper.stringForKey("authenticationToken") {
            
            Alamofire.request(.PUT, Constants.apiBaseURL + "userprofile/podiums", parameters: body, encoding: .JSON, headers: ["Authorization":"bearer \(retrievedString)" ]).responseJSON(completionHandler: { JSON in
                print(JSON)
                if let callBack = callBack {
                    
                    print("Uploading Medalist Points - Finished")
                    
                    callBack()
                }
            })
        }
    }
}
