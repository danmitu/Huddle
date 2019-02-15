//
//  CalendarViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/18/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class CalendarViewController: UITableViewController {
    
    // TODO: delete me
    private var eventData = [
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Date(), location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, location: "Ferry Point Park")
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
    }
    
    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        let event = eventData[indexPath.row]
        cell.set(eventName: event.name, groupName: event.groupName, date: event.date, location: event.location)

        return cell
     }
    
}
