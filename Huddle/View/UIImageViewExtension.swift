//
//  UIImageViewExtension.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

extension UIImageView {
    
    /// Masks the `UIImageView` with a circle.
    ///
    /// - Parameter image: The image to be used.
    public func maskCircle(withImage image: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.image = image
    }

}
