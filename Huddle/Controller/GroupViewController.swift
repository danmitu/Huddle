//
//  GroupViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/13/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {
    
    // MARK: - Temporary Placeholders
    
    // TODO: Delete Me
    
    private var eventData = [
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Date(), location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, location: "Ferry Point Park"),
        Event(name: "Monthly Demos", groupName: "BAY AREA TECH MEETUP", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, location: "Ferry Point Park")
    ]
    
    // TODO: Delete Me
    
    private var memberIDData = [1,2,3,4,5]
    
    
    // MARK: - Initialization
    
    init(groupId: Int) {
        self.targetGroupId = groupId
        super.init(style: .grouped)
        performNetworkRequest()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) is not supported") }
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    let targetGroupId: Int
    
    private var group: Group? {
        didSet {
            tableView.beginUpdates()
            groupHeaderView.groupNameLabel.text = group?.title
            groupHeaderView.groupLocationLabel.text = group?.location?.name
            groupHeaderView.groupCategoryLabel.text = group?.category.name
            aboutTableViewCell.textLabel?.text = group?.description
            tableView.endUpdates()
        }
    }
    
    private var isMember: Bool = false {
        didSet {
            let buttonTitle = isMember ? "Leave Group" : "Join Group"
            joinButtonCell.button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private var isOwner: Bool = true
    
    private enum Section: Int, CaseIterable {
        case about
        case join
        case members
        case events
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performNetworkRequest()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        navigationItem.rightBarButtonItem = isOwner ? UIBarButtonItem(image: DrawCode.imageOfKebabIcon(isSelected: false), style: .plain, target: self, action: #selector(kebabIconWasTapped)) : nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .white
        tableView.tableHeaderView = groupHeaderView
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        joinButtonCell.button.addTarget(self, action: #selector(joinButtonWasPressed), for: .touchUpInside)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isBeingPresented {
            performNetworkRequest()
        }
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
        cell.selectionStyle = .none
        return cell
    }()
    
    private let membersTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "All Members (0)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    private let joinButtonCell: FilledButtonTableViewCell = {
        let cell = FilledButtonTableViewCell(reuseIdentifier: "button", showSeparators: false)
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
        case .events: return "Upcoming Events"
        case .join: return " "
        case .members: return " "
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section)! {
        case .join, .members:
            return CGFloat.leastNonzeroMagnitude
        default:
            return UITableView.automaticDimension
        }
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
    
    // MARK: - Actions
    
    @objc private func kebabIconWasTapped() {
        let optionMenu = UIAlertController(title: nil, message: "Chose Option", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit Group", style: .default, handler: {
            action in
            
            let editGroupViewController = GroupEditorViewController(style: .grouped)
            editGroupViewController.group = self.group
            let navigationController = UINavigationController(rootViewController: editGroupViewController)
            self.present(navigationController, animated: true)
        })
        
        let createEventAction = UIAlertAction(title: "Create Event", style: .default, handler: {
            action in
            
            let createEventViewController = ProfileEditorViewController(style: .grouped)
            let navigationController = UINavigationController(rootViewController: createEventViewController)
            self.present(navigationController, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(editAction)
        optionMenu.addAction(createEventAction)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func joinButtonWasPressed(sender: UIButton) {
        joinButtonCell.button.isEnabled = false
        if isMember {
            networkManager.removeSelf(fromGroup: targetGroupId, completion: { [weak self] error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let _self = self else { return }
                _self.isMember = false
                _self.joinButtonCell.button.isEnabled = true
            })
        } else {
            networkManager.join(group: targetGroupId, completion: { [weak self] error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let _self = self else { return }
                _self.isMember = true
                _self.joinButtonCell.button.isEnabled = true
            })
        }
    }
    
    @objc private func refresh() {
        performNetworkRequest() { [weak self] in
            self?.refreshControl!.endRefreshing()
        }
    }
    
    // MARK: - Helper Methods
    
    private func performNetworkRequest(completion: (()->())? = nil) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        networkManager.read(group: targetGroupId) { [weak self] group, error in
            guard error == nil else {
                print(error!)
                return
            }
            self?.group = group
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.checkSelfIsMember(withinGroup: targetGroupId) { [weak self] value, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let isMember = value else { return }
            self?.isMember = isMember
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.checkSelfIsOwner(withinGroup: targetGroupId) { [weak self] value, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let isOwner = value else { return }
            self?.isOwner = isOwner
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    
}