//
//  Category.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import Foundation

enum Category : Int, CaseIterable, Hashable {
    case none = 0
    case social = 1
    case careerBusiness = 2
    case bookclub = 3
    case fitness = 4
    case other
    
    var description : String {
        get {
            switch(self) {
            case .none:
                return "None"
            case .social:
                return "For the socialites."
            case .careerBusiness:
                return "Better yourself and build your network."
            case .bookclub:
                return "Read and discuss."
            case .fitness:
                return "Get healthy together."
            case .other:
                return "Unknown"
            }
        }
    }
    var name : String {
        get {
            switch (self) {
            case .none:
                return "None"
            case .social:
                return "Social"
            case .careerBusiness:
                return "Career And Business"
            case .bookclub:
                return "Book Clubs"
            case .fitness:
                return "Fitness"
            case .other:
                return "Unknown"
            }
        }
    }
}
