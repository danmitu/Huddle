//
//  User.swift
//  Huddle
//
//  Created by Dan Mitu on 2/5/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation
import MapKit

fileprivate struct RawMember: Decodable {
    let id: Int
    let email: String
    let name: String?
    let bio: String?
    let locationid: Int?
    let location: String?
    let latitude: Float?
    let longitude: Float?
    let publiclocation: Bool
    let publicgroup: Bool
    let joindate: String
}

struct Member: Decodable {
    var id: Int
    var email: String
    var name: String?
    var bio: String?
    var homeLocation: NamedLocation?
    var publicGroup: Bool
    var publicLocation: Bool
    var joindate: Date
    var profilePhoto: UIImage?
    
    init(from decoder: Decoder) throws {
        let rawMember = try RawMember(from: decoder)
        self.id = rawMember.id
        self.email = rawMember.email
        self.name = rawMember.name
        self.bio = rawMember.bio
        self.publicGroup = rawMember.publicgroup
        self.publicLocation = rawMember.publiclocation
        
        if let rawLocationName = rawMember.location,
            let rawLatitude = rawMember.latitude,
            let rawLongitude = rawMember.longitude,
            let rawLocationId = rawMember.locationid {
            let location = CLLocation(latitude: CLLocationDegrees(rawLatitude), longitude: CLLocationDegrees(rawLongitude))
            self.homeLocation = NamedLocation(id: rawLocationId, name: rawLocationName, location: location)
        } else {
            self.homeLocation = nil
        }
        
        self.joindate = rawMember.joindate.toDate() ?? Date()
    }
}
