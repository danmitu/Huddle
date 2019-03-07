//
//  ButtonFieldTableViewCell.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

class FilledButtonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var showSeparators: Bool
    
    // MARK: - Initialization
    
    init(reuseIdentifier: String, showSeparators: Bool) {
        self.showSeparators = showSeparators
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - Subviews
    
    let button: FilledButton = {
        let button = FilledButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Title", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!showSeparators) {
            for view in subviews where view != contentView {
                view.removeFromSuperview()
            }
        }
    }
    
}
