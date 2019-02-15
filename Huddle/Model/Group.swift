//
//  Group.swift
//  Huddle
//
//  Created by Dan Mitu on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation
import MapKit

struct RawGroup: Decodable {
    let id: Int
    let title: String?
    let description: String
    let ownerid: Int
    let owner: String?
    let locationid: Int?
    let location: String?
    let latitude: Float?
    let longitude: Float?
    let memberid: Int?
    let categoryid: Int?
    let categoryname: String?
    let categorydescription: String?
    let distance: Int?
}

struct Group: Decodable, Hashable {
    var id: Int
    var title: String?
    var description: String
    var ownerId: Int
    var ownerName: String?
    var location: NamedLocation?
    
    init(from decoder: Decoder) throws {
        let rawGroup = try RawGroup(from: decoder)
        self.id = rawGroup.id
        self.title = rawGroup.title
        self.description = rawGroup.description
        self.ownerId = rawGroup.ownerid
        self.ownerName = rawGroup.owner
        
        if let rawLocationName = rawGroup.location,
            let rawLatitude = rawGroup.latitude,
            let rawLongitude = rawGroup.longitude,
            let rawLocationId = rawGroup.locationid {
            let location = CLLocation(latitude: CLLocationDegrees(rawLatitude), longitude: CLLocationDegrees(rawLongitude))
            self.location = NamedLocation(id: rawLocationId, name: rawLocationName, location: location)
        } else {
            self.location = nil
        }
    }
}
