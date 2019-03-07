//
//  CalendarViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

class CalendarViewController: AsyncTableViewController {
    
    private let networkManager = NetworkManager()
    
    private var events: [Event]? { didSet { tableView.reloadData() } }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        performNetworkRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isBeingPresented {
            performNetworkRequest()
        }
    }
    
    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        let event = events![indexPath.row]
        cell.set(eventName: event.name, groupName: "", date: event.start, location: event.location.name)
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventPage = EventViewController(eventId: events![indexPath.row].id)
        navigationController?.pushViewController(eventPage, animated: true)
    }
    
    private func performNetworkRequest() {
        networkManager.getCalendar() { [weak self] error, events in
            guard self != nil && self!.responseErrorHandler(error, events) else { return }
            self?.events = events!
            self?.tableView.reloadData()
        }
    }
    
}
