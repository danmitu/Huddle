//
//  FilledButton.swift
//  Huddle
//
//  Created by Dan Mitu on 1/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

/// This button changes it's background color based on whether it's highlighted or enabled.
class FilledButton: UIButton {
    
    var highlightedBackgroundColor: UIColor = .clear
    
    var normalBackgroundColor: UIColor = .clear
    
    var disabledBackgroundColor: UIColor = .clear
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? normalBackgroundColor : disabledBackgroundColor
        }
    }

}
