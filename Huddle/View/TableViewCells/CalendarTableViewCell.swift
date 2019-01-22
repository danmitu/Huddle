//
//  CalendarTableViewCell.swift
//  Huddle
//
//  Created by Dan Mitu on 1/18/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateAccessory.addArrangedSubview(weekdayLabel)
        dateAccessory.addArrangedSubview(numberDayLabel)
        contentView.addSubview(dateAccessory)
        contentView.addSubview(eventView)
        
        NSLayoutConstraint.activate([
            eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            eventView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            eventView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            eventView.leadingAnchor.constraint(equalTo: dateAccessory.trailingAnchor, constant: 4),
            dateAccessory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            dateAccessory.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            dateAccessory.widthAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    func set(eventName: String, groupName: String, date: Date, location: String) {
        eventView.set(eventName: eventName, groupName: groupName, location: location, date: date)
        numberDayLabel.text = String(Calendar.current.component(.day, from: date))
        let weekday = Calendar.current.component(.weekday, from: date)
        switch weekday {
        case 1: weekdayLabel.text = "SUN"
        case 2: weekdayLabel.text = "MON"
        case 3: weekdayLabel.text = "TUE"
        case 4: weekdayLabel.text = "WED"
        case 5: weekdayLabel.text = "THU"
        case 6: weekdayLabel.text = "FRI"
        case 7: weekdayLabel.text = "SAT"
        default: fatalError("impossible")
        }
    }
    
    // MARK: - Subviews
    
    private let eventView: EventView = {
        let view = EventView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateAccessory: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    private let numberDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.sizeToFit()
        return label
    }()
}
