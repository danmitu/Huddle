//
//  UIViewControllerExtension.swift
//  Huddle
//
//  Created by Dan Mitu on 3/2/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Displays a simple error message with an okay button. The last resort for error handling.
    func displayError(message: String, _ completion: @escaping ()->()) {
        OkPresenter(title: "Error", message: message, handler: completion).present(in: self)
    }

    
}
