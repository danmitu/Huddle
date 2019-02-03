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
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
        // make the background black and halfway transparent
        self.backgroundColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.5)
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Subviews
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}
