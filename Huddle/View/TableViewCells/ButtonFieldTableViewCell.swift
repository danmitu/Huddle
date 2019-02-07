//
//  ButtonFieldTableViewCell.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/6/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ButtonFieldTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var showSeparators: Bool
    
    // MARK: - Initialization
    
    init(reuseIdentifier: String, showSeparators: Bool) {
        self.showSeparators = showSeparators
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        containerStackView.addArrangedSubview(button)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
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
//        button.addTarget(self, action: #selector(showRegisterController), for: .touchUpInside)
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
    
//    let button: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Title", for: .normal)
//        return button
//    }()
    
//    private let containerStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 8
//        return stackView
//    }()
    
}
