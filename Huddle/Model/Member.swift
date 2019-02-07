//
//  User.swift
//  Huddle
//
//  Created by Dan Mitu on 2/5/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation

struct Member: Decodable {
    var id: Int
    var name: String?
    var email: String?
    var bio: String?
    var publicGroup: Bool
    var publicLocation: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case bio
        case publicGroup = "publicgroup"
        case publicLocation = "publiclocation"
    }
    
}
