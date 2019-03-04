//
//  CalendarViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/18/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class CalendarViewController: UITableViewController {
    
    private let networkManager = NetworkManager()
    
    private var events: [Event]? { didSet { tableView.reloadData() } }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        performNetworkRequest()
    }
    
    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        let event = events![indexPath.row]
        // TODO: Fix group
        cell.set(eventName: event.name, groupName: "group name", date: event.start, location: event.location.name)

        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventPage = EventViewController(eventId: events![indexPath.row].id)
        navigationController?.pushViewController(eventPage, animated: true)
    }
    
    private func performNetworkRequest() {
        networkManager.getCalendar() { [weak self] error, events in
            self?.events = events
        }
    }
    
}
