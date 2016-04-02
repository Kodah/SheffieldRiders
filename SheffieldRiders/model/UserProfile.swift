//
//  UserProfile.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 02/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import Foundation
import Gloss
import SwiftKeychainWrapper

struct SpotsVisited: Decodable {
    
    let name: String
    let visitCount: Int
    
    
    init?(json: JSON) {
        guard let name: String = "name" <~~ json,
            let visitCount: Int = "visitCount" <~~ json else { return nil }
        self.name = name
        self.visitCount = visitCount
    }
}

struct UserProfile : Decodable {
    let username: String
    let quote: String?
    let discipline: String?
    let riderRep: Int
    let spotsVisited: [SpotsVisited]
        
    init?(json: JSON) {
        guard let username: String = "username" <~~ json,
            let quote: String = "quote" <~~ json,
            let discipline: String = "discipline" <~~ json,
            let riderRep: Int = "riderRep" <~~ json,
            let spotsVisited: [SpotsVisited] = [SpotsVisited].fromJSONArray(("spotsVisted" <~~ json)!) else {
                return nil
        }
        
        self.username = username
        self.quote = quote
        self.discipline = discipline
        self.riderRep = riderRep
        self.spotsVisited = spotsVisited
    }
}