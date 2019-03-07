//
//  UIViewControllerExtension.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

extension UIViewController {
    
    /// Displays a simple error message with an okay button. The last resort for error handling.
    func displayError(message: String, _ completion: @escaping ()->()) {
        OkPresenter(title: "Error", message: message, handler: completion).present(in: self)
    }
    
}
