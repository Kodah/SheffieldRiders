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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
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
    
    
    
    
    func applicationWillTerminate(application: UIApplication) {

        KeychainWrapper.removeObjectForKey("authenticationToken")
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {

        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {

        let modelURL = NSBundle.mainBundle().URLForResource("SheffieldRiders", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)

            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {

        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {

                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

