//
//  Utility.swift
//  Huddle
//
//  Created by Dan Mitu on 1/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import Foundation

func isValidEmail(testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
