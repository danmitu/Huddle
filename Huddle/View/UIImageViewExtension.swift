//
//  UIImageViewExtension.swift
//  Huddle
//
//  Created by Dan Mitu on 2/1/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
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
