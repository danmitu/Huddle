//
//  NamedLocation.swift
//  Huddle
//
//  Created by Dan Mitu on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation
import MapKit

struct NamedLocation: Hashable {
    var id: Int
    var name: String
    var location: CLLocation
}
