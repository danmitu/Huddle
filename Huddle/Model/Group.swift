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
    let description: String?
    let ownerid: Int
    let owner: String?
    let locationid: Int?
    let location: String?
    let latitude: Float?
    let longitude: Float?
    let memberid: Int?
    let categoryid: Int?
    let distance: Int?
}

struct Group: Decodable, Hashable {
    var id: Int
    var title: String?
    var description: String?
    var ownerId: Int
    var ownerName: String?
    var location: NamedLocation?
    var category: Category
    
    // TODO: delete me
    // For Testing. This needs to be removed
    init(id: Int, title: String, description: String, ownerID: Int, locationName: String, category: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.ownerId = ownerID
        self.location = NamedLocation(id: 1, name: locationName, location: CLLocation(latitude: CLLocationDegrees(1), longitude: CLLocationDegrees(1)))
        self.category = Category(rawValue: category) ?? .none
    }
    
    init(from decoder: Decoder) throws {
        let rawGroup = try RawGroup(from: decoder)
        self.id = rawGroup.id
        self.title = rawGroup.title
        self.description = rawGroup.description
        self.ownerId = rawGroup.ownerid
        self.ownerName = rawGroup.owner
        self.category = Category(rawValue: rawGroup.categoryid ?? 0) ?? .none
        
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
