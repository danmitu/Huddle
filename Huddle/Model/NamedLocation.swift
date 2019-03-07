//
//  NamedLocation.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import Foundation
import MapKit

struct NamedLocation: Hashable {
    var id: Int
    var name: String
    var location: CLLocation
}
