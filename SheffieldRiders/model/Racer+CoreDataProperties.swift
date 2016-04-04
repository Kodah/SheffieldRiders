//
//  Racer+CoreDataProperties.swift
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

extension Racer {

    @NSManaged var name: String?
    @NSManaged var startDate: NSNumber?
    @NSManaged var finishDate: NSNumber?
    @NSManaged var id: String?
    @NSManaged var race: Race?

}
