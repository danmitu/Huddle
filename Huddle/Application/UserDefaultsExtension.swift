//
//  UserDefaultsExtension.swift
//  Huddle
//
//  Created by Dan Mitu on 1/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation

extension UserDefaults {

    var isLoggedIn: Bool {
        get {
            // return the value in UserDefaults, or false if there is no value
            return UserDefaults.standard.value(forKey: "IsLoggedIn") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
}
