//
//  GroupViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    
    private var group: Group? {
        didSet {
//            navigationItem.title = group?.title
            groupHeaderView.groupNameLabel.text = group?.title
            groupHeaderView.groupLocationLabel.text = group?.location?.name
            groupHeaderView.groupCategoryLabel.text = "Category"
            aboutTableViewCell.textLabel?.text = group?.description
        }
    }
    
    private enum Section: Int, CaseIterable {
        case about
        case join
        case members
        case events
    }
    
    // TODO: delete me
//    fileprivate struct Event {
//        let name: String
//        let groupName: String
//        let date: Date
//        let location: String
//    }
    
    // TODO: delete me
    private var eventData = [
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Date(), location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, location: "Ferry Point Park")
    ]
    
    private var memberIDData = [1,2,3,4,5]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Test Group"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonWasTapped))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .white
        tableView.tableHeaderView = groupHeaderView
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        joinButtonCell.button.addTarget(self, action: #selector(join), for: .touchUpInside)
        
        
//        self.group = testGroup
//        networkManager.readProfile(id: memberID) { [weak self] member, error in
//            guard error == nil else {
//                print(error! as String)
//                return
//            }
//            self?.member = member
//        }
    }
    
    // MARK: - Static Cells
    
    let groupHeaderView: GroupHeaderView = {
        let view = Bundle.main.loadNibNamed("GroupHeaderView", owner: self, options: nil)![0] as! GroupHeaderView
        view.autoresizingMask = .flexibleWidth
        view.translatesAutoresizingMaskIntoConstraints = true
        
        view.groupNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        view.groupLocationLabel.textColor = .lightGray
        view.groupLocationLabel.font = UIFont(name: "Avenir-Book", size: 16)
        view.groupCategoryLabel.textColor = .lightGray
        view.groupCategoryLabel.font = UIFont(name: "Avenir-Book", size: 16)
        return view
    }()
    
    private let aboutTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }()
    
    private let membersTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "All Members (0))"
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    private let joinButtonCell: FilledButtonTableViewCell = {
//        let cell = ButtonFieldTableViewCell(reuseIdentifier: "ButtonFieldTableViewCell", showSeparators: false)
        let cell = FilledButtonTableViewCell(reuseIdentifier: "button", showSeparators: false)
        cell.button.setTitle("Join", for: .normal)
        cell.button.setTitle("Joined", for: .disabled)
        //        cell.button.setTitleColor(UIColor.preferredTeal, for: .normal)
//        cell.button.addTarget(self, action: #selector(join), for: .touchUpInside)
//        cell.button.isEnabled = true
        return cell
    }()
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .about:
            return 1
        case .members:
            return 1
        case .events:
            return eventData.count > 3 ? 3 : eventData.count
        case .join:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch Section(rawValue: indexPath.section)! {
        case .about:
            cell = aboutTableViewCell
        case .events:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
            
            let event = eventData[indexPath.row]
            cell.set(eventName: event.name, groupName: event.groupName, date: event.date, location: event.location)
            
            return cell
        case .join:
            cell = joinButtonCell
        case .members:
            cell = membersTableViewCell
            cell.textLabel?.text = "All Members (\(memberIDData.count))"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .about: return "About"
        case .events: return "Events"
        case .join: return " "
        case .members: return "Members"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if Section(rawValue: section)! == .members || Section(rawValue: section)! == .join {
            return CGFloat.leastNonzeroMagnitude
        }
        return UITableView.automaticDimension
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        headerView.textLabel?.textColor = UIColor.lightGray
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Section(rawValue: indexPath.section) == .members {
            let groupMembersViewController = GroupMembersViewController(memberIDsToShow: self.memberIDData)
            navigationController?.pushViewController(groupMembersViewController, animated: true)
        }
    }
    
    func set(groupToSet: Group) {
        group = Group(id: 1, title: "Test Group Name", description: "Test Group", ownerID: 1, locationName: "Test Location")
    }
    
    // MARK: - Actions
    
    @objc private func editButtonWasTapped() {
        // GA TODO: Change this to GroupEditorViewController
        let editorViewController = ProfileEditorViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: editorViewController)
        present(navigationController, animated: true)
    }
    
    @objc func join(sender: UIButton) {
        if (joinButtonCell.button.isEnabled) {
            joinButtonCell.button.isEnabled = false;
        }
    }
    
    
}
