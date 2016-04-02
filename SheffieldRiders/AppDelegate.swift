//
//  AppDelegate.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 10/02/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper
import DATAStack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var dataStack: DATAStack = DATAStack(modelName: "SheffieldRiders")
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let retrievedString: String? = KeychainWrapper.stringForKey("authenticationToken")
        
        navControllerListeners()
        
        if ((retrievedString ?? "").isEmpty) {
            
            print("needs to login or register")
            
            
            if let window = self.window {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let logInVC = storyboard.instantiateViewControllerWithIdentifier("authenticationVC")
                window.rootViewController = logInVC
            }
            
        } else {
            
            print("logged in", retrievedString)
            
        }
        
        return true
    }
    
    func navControllerListeners () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.changeNavRootView(_:)), name: "menuOptionSelected", object: nil)
    }
    
    func changeNavRootView (notification:NSNotification)
    {
        
        if let userInfo = notification.userInfo,
            selectedControllerName = userInfo["selectedController"] as? String
        {
            print(selectedControllerName)
            
            let navController = self.window?.rootViewController as! UINavigationController
            
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(selectedControllerName)
            
            navController.viewControllers = [viewController]
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        self.dataStack.persistWithCompletion(nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.dataStack.persistWithCompletion(nil)
        KeychainWrapper.removeObjectForKey("authenticationToken")
    }
}

