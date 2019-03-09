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
                return "Social Description"
            case .careerBusiness:
                return "Career And Business Description"
            case .bookclub:
                return "Book Clubs Description"
            case .fitness:
                return "Fitness Description"
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
