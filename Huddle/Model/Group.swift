//
//  Group.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import Foundation
import MapKit

fileprivate struct RawGroup: Decodable {
    let id: Int
    let title: String
    let description: String
    let ownerid: Int
    let owner: String
    let locationid: Int
    let location: String
    let latitude: Float
    let longitude: Float
    let memberid: Int
    let categoryid: Int
    let distance: Float
}

struct Group: Decodable, Hashable {
    let id: Int
    let title: String
    let description: String
    let ownerId: Int
    let ownerName: String
    let location: NamedLocation
    let category: Category
    let distance: Float
    
    init(id: Int, title: String, description: String, ownerId: Int, ownerName: String, location: NamedLocation, distance: Float, category: Category) {
        self.id = id
        self.title = title
        self.description = description
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.location = location
        self.distance = distance
        self.category = category
    }
    
    init(from decoder: Decoder) throws {
        let rawGroup = try RawGroup(from: decoder)
        self.id = rawGroup.id
        self.title = rawGroup.title
        self.description = rawGroup.description
        self.ownerId = rawGroup.ownerid
        self.ownerName = rawGroup.owner
        self.category = Category(rawValue: rawGroup.categoryid) ?? .none
        self.distance = rawGroup.distance
        
        let location = CLLocation(latitude: CLLocationDegrees(rawGroup.latitude), longitude: CLLocationDegrees(rawGroup.longitude))
        self.location = NamedLocation(id: rawGroup.locationid, name: rawGroup.location, location: location)
    }
}
