//
//  Event.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation
import MapKit

fileprivate struct RawEvent: Decodable {
    var id: Int
    var groupid: Int
    var title: String
    var description: String
    var locationid: Int
    var location: String
    var latitude: Double
    var longitude: Double
    var start: String
    var end: String
    var attending: Bool
}

struct Event: Decodable {
    var id: Int
    var groupId: Int
    var name: String
    var description: String
    var location: NamedLocation
    var start: Date
    var end: Date
    var rsvp: Bool
    
    init(id: Int, groupId: Int, name: String, description: String, location: NamedLocation, start: Date, end: Date, rsvp: Bool) {
        self.id = id
        self.groupId = groupId
        self.name = name
        self.description = description
        self.location = location
        self.start = start
        self.end = end
        self.rsvp = rsvp
    }
    
    init(from decoder: Decoder) throws {
        let rawEvent = try RawEvent(from: decoder)
        self.id = rawEvent.id
        self.groupId = rawEvent.groupid
        self.name = rawEvent.title
        self.description = rawEvent.description
        self.start = rawEvent.start.toDate()!
        self.end = rawEvent.end.toDate()!
        self.rsvp = rawEvent.attending
        
        self.location = {
            let location = CLLocation(latitude: CLLocationDegrees(rawEvent.latitude), longitude: CLLocationDegrees(rawEvent.longitude))
            return NamedLocation(id: rawEvent.locationid, name: rawEvent.location, location: location)
        }()
    }
}
