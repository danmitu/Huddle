//
//  ProfileAboutTableViewCell.swift
//  Huddle
//
//  Created by Dan Mitu on 1/30/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ProfileAboutTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileAboutTableViewCell"
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Subviews
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = str
        return label
    }()
    
}

// TODO: delete me
fileprivate let str = """
Lorem ipsum dolor sit amet, an est meis placerat. Alia imperdiet scribentur pro in, vel ex tale nonumy, ei quo everti necessitatibus. Eos dictas timeam pericula te. Vix ea facer gloriatur, docendi torquatos quaerendum vis ex.
"""
