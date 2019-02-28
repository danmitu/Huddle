//
//  GroupTableViewCell.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/26/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    
    // MARK: - Initialization
    
    var groupID = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(groupView)
        
        NSLayoutConstraint.activate([
            groupView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            groupView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            groupView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            groupView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - Subviews
    
    private let groupView: GroupView = {
        let view = GroupView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK - Other
    func set(groupName: String, distance: Float, description: String, id: Int) {
        groupView.set(groupName: groupName, distance: distance, description: description)
        groupID = id
    }
    
}
