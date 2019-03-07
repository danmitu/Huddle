//
//  FilledButton.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
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
