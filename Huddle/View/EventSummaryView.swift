//
//  EventView.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

// Displays basic information about an event.
// Has three lines (in order): group name, event name, date at location.
class EventSummaryView: UIStackView {

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        addArrangedSubview(groupNameLabel)
        addArrangedSubview(eventNameLabel)
        addArrangedSubview(locationAndDateLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Subviews
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    
    private let locationAndDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        return label
    }()
    
    // Helper function for maintaining consistency.
    // Date string is relative i.e. "Today", "Yesterday", "Tomorrow"
    // Group name is set to all caps.
    func set(eventName: String, groupName: String, location: String, date: Date) {
        let dateString: String
        
        if Calendar.current.isDateInToday(date) {
            dateString = "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            dateString = "Yesterday"
        } else if Calendar.current.isDateInTomorrow(date) {
            dateString = "Tomorrow"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateString = dateFormatter.string(from: date)
        }
        
        locationAndDateLabel.text = "\(dateString) at \(location)"
        self.groupNameLabel.text = groupName.uppercased()
        self.eventNameLabel.text = eventName
    }

}
