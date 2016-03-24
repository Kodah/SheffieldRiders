//
//  constants.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 11/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import Foundation


struct Constants {
    
    static let apiBaseURL = "http://localhost:3000/"
    
    
}



enum MainViewControllers : String {
    case Profile = "Profile"
    case News = "News"
    case Events = "Events"
    case Locations = "Locations"
    case Projects = "Projects"
    case polls = "Polls"
    
    func stringIdentifier () -> String {
        switch self {
        case Profile:
            return "ProfileViewController"
        case News:
            return "NewsViewController"
        case Events:
            return "EventsViewController"
        case Locations:
            return "LocationsViewController"
        case Projects:
            return "ProjectsViewController"
        case polls:
            return "PollsViewController"
        }
    }
}