//
//  PleaseWaitView.swift
//  Huddle
//
//  Created by Dan Mitu on 1/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

/// Blocks the screen with semi-transparently and shows a spinning activity indicator.
class PleaseWaitView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
        // make the background black and halfway transparent
        self.backgroundColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.5)
        activityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .whiteLarge)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
}
