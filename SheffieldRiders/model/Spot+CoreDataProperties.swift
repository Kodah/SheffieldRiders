//
//  Spot+CoreDataProperties.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 02/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Spot {

    @NSManaged var name: String?
    @NSManaged var remoteID: String?
    @NSManaged var visitCount: NSNumber?
    @NSManaged var userProfile: UserProfile?

}
