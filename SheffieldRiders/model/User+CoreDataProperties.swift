//
//  User+CoreDataProperties.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 03/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var rep: NSNumber?
    @NSManaged var username: String?

}
