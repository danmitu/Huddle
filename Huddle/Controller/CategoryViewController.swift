//
//  CategoryViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/19/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController, UINavigationControllerDelegate {
    
    // TODO: delete me
    private var eventData = [Event]()
//    private var eventData = [
//        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Date(), location: "Ferry Point Park"),
//        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, location: "Ferry Point Park"),
//        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, location: "Ferry Point Park")
//    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
    }
    
    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.allCases.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cat = Category(rawValue: indexPath.row + 1) ?? .none
        cell.textLabel?.text = cat.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        whenSelected?(Category(rawValue: indexPath.row + 1) ?? .none)
        navigationController?.popViewController(animated: true)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
//        whenSelected?(textView.text ?? "")
    }
    
    // MARK: - Properties
    
    var whenSelected: ((Category)->())?
    
}
