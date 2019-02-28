//
//  GroupView.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/26/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

// Displays basic information about an event.
// Has three lines (in order): group name, event name, date at location.
class GroupView: UIStackView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        groupAndDistanceStack.addArrangedSubview(groupNameLabel)
        groupAndDistanceStack.addArrangedSubview(groupDistanceLabel)
        addArrangedSubview(groupAndDistanceStack)
        addArrangedSubview(descriptionLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Subviews
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    
    private let groupDistanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    
    private let groupAndDistanceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        label.numberOfLines = 2
        return label
    }()
    
    
    // Helper function for maintaining consistency.
    // Group name is set to all caps.
    func set(groupName: String, distance: Float, description: String) {
        descriptionLabel.text = description
        groupNameLabel.text = groupName
        var distanceText = ""
        if (distance < 1) {
            distanceText = "< 1 mile away"
        } else {
            distanceText = String(format: "%d miles away", Int(distance))
        }
        groupDistanceLabel.text = distanceText
//        nameAndDistanceTextLabel.text = String(format: "\(groupName.uppercased()): (%.02f miles away)", distance)
    }
    
}
