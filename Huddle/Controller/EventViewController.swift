//
//  EventViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 2/21/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController {

    init(eventId: Int) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Properties
    
    private var isGroupMember: Bool = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Event"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(userDidPressEditButton)), animated: true)
        tableView.isUserInteractionEnabled = true
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableHeaderView!.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(30))
    }
    
    // MARK: - Other Views
    
    let headerView: EventViewHeader = {
        let view = Bundle.main.loadNibNamed("EventViewHeader", owner: self, options: nil)![0] as! EventViewHeader
        return view
    }()
    
    // MARK: - Static Cells
    
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 35)
        label.text = "Monthly Demos"
        label.numberOfLines = 2
        return label
    }()
    
    private let groupNameCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Bay Area Tech Meetup"
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        cell.directionalLayoutMargins = .zero
        return cell
    }()

    private let rsvpButtonCell: FilledButtonTableViewCell = {
        let cell = FilledButtonTableViewCell(reuseIdentifier: "", showSeparators: false)
        cell.button.setTitle("RSVP", for: .normal)
        return cell
    }()
    
    private let locationCell: DoubleLabelTableViewCell = {
        let cell = DoubleLabelTableViewCell()
        cell.topLabel.textColor = .gray
        cell.topLabel.font = .boldSystemFont(ofSize: 16)
        cell.bottomLabel.textColor = .gray
        cell.topLabel.text = "Location"
        cell.bottomLabel.text = "The Cool Place"
        return cell
    }()

    private let whenCell: DoubleLabelTableViewCell = {
        let cell = DoubleLabelTableViewCell()
        cell.topLabel.textColor = .gray
        cell.topLabel.font = .boldSystemFont(ofSize: 16)
        cell.bottomLabel.textColor = .gray
        cell.topLabel.text = "When"
        cell.bottomLabel.text = "1/2/21, 5:00PM - 8:30PM"
        return cell
    }()
    
    private let descriptionCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.selectionStyle = .none
        cell.textLabel?.text = "The techy people will meetup to show each other the stuff. It will be very techy. I'm so sleep deprived. Someone send help."
        return cell
    }()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return groupNameCell
        case 1: return rsvpButtonCell
        case 2: return locationCell
        case 3: return whenCell
        case 4: return descriptionCell
        default: fatalError("Unreachable")
        }

    }
    
    // MARK: - Actions
    
    @objc func userDidPressEditButton() { 
        let editorViewController = EventEditorViewController(for: .editing)
        let editorNavigationController = UINavigationController(rootViewController: editorViewController)
        present(editorNavigationController, animated: true)
    }
    
}
