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
    case category1 = 1
    case category2 = 2
    case category3 = 3
    case other
    
    var description : String {
        get {
            switch(self) {
            case .none:
                return "None"
            case .category1:
                return "Cat 1"
            case .category2:
                return "category 2"
            case .category3:
                return "Category is 3"
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
            case .category1:
                return "Category 1"
            case .category2:
                return "Category 2"
            case .category3:
                return "Category 3"
            case .other:
                return "Unknown"
            }
        }
    }
}
