//
//  Category.swift
//  Huddle
//
//  Created by Dan Mitu on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation

enum Category : Int, CaseIterable, Hashable {
    case none = 0
    case category1 = 1
    case category2 = 2
    case category3 = 3
    
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
            }
        }
    }
}
