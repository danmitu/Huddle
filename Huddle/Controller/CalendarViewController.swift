//
//  CalendarViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/18/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class CalendarViewController: UITableViewController {
    
    // Temporary Test Data
    private var eventData = [
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Date(), location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, location: "Ferry Point Park")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
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

// MARK: - Temporary

fileprivate struct Event {
    let name: String
    let groupName: String
    let date: Date
    let location: String
}
