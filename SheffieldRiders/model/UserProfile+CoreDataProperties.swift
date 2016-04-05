//
//  UserProfile+CoreDataProperties.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 05/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserProfile {

    @NSManaged var discipline: String?
    @NSManaged var quote: String?
    @NSManaged var rep: NSNumber?
    @NSManaged var username: String?
    @NSManaged var third: NSNumber?
    @NSManaged var second: NSNumber?
    @NSManaged var won: NSNumber?
    @NSManaged var race_count: NSNumber?
    @NSManaged var spots: NSSet?

}
