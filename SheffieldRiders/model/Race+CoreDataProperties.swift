//
//  Race+CoreDataProperties.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 04/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Race {

    @NSManaged var title: String?
    @NSManaged var creator: String?
    @NSManaged var id: String?
    @NSManaged var location: String?
    @NSManaged var date: NSDate?
    @NSManaged var racers: NSSet?

}
