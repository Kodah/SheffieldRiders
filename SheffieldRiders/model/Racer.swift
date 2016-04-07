//
//  Racer.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 04/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import Foundation
import CoreData


class Racer: NSManagedObject {
    
    func raceTime() -> Int {
        if let finishDateInt = finishDate?.integerValue, startDateInt = startDate?.integerValue {
            return finishDateInt - startDateInt
        } else{
            return 99999
        }
        
    }
    
    func raceTimeString() -> String {
        
        if (startDate == nil)  {
            return "DNS"
        }
        if (finishDate == nil) {
            return "DNF"
        } else {
            let duration = finishDate!.intValue - startDate!.intValue
            let minutes = duration / 60;
            let seconds = duration % 60;
            return NSString(format: "%d:%02d", minutes, seconds) as String
        }
        
    }
}
