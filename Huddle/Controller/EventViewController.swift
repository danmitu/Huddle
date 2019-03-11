//
//  EventViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

fileprivate struct EventViewModel {
    let personalId: Int
    var event: Event
    let group: Group
    let isGroupMember: Bool
}

class EventViewController: AsyncTableViewController {

    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    private let eventId: Int
    
    private var viewModel: EventViewModel?
    
    // MARK: - Initialization
    
    init(eventId: Int) {
        self.eventId = eventId
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) is not supported") }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performNetworkRequest()
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .white
        performNetworkRequest()
        rsvpButtonCell.button.addTarget(self, action: #selector(userDidPressRSVPButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isBeingPresented {
            performNetworkRequest()
        }
    }
    
    // MARK: - Other Views
    
    let headerView: EventViewHeader = {
        let view = Bundle.main.loadNibNamed("EventViewHeader", owner: self, options: nil)![0] as! EventViewHeader
        // Anything else needed here...?
        return view
    }()
    
    // MARK: - Static Cells
    
    private var cellLayout: [UITableViewCell]?
    
    private let groupNameCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "???"
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        cell.directionalLayoutMargins = .zero
        return cell
    }()
    
    private let rsvpButtonCell: FilledButtonTableViewCell = {
        let cell = FilledButtonTableViewCell(reuseIdentifier: "", showSeparators: false)
        cell.button.setTitle("RSVP", for: .normal)
        cell.selectionStyle = .none
        return cell
    }()
    
    private let locationCell: DoubleLabelTableViewCell = {
        let cell = DoubleLabelTableViewCell()
        cell.topLabel.textColor = .gray
        cell.topLabel.font = .boldSystemFont(ofSize: 16)
        cell.bottomLabel.textColor = .gray
        cell.topLabel.text = "Location"
        cell.bottomLabel.text = " "
        cell.selectionStyle = .none
        return cell
    }()
    
    private let whenCell: DoubleLabelTableViewCell = {
        let cell = DoubleLabelTableViewCell()
        cell.topLabel.textColor = .gray
        cell.topLabel.font = .boldSystemFont(ofSize: 16)
        cell.bottomLabel.textColor = .gray
        cell.topLabel.text = "When"
        cell.bottomLabel.text = "???"
        cell.selectionStyle = .none
        return cell
    }()
    
    private let descriptionCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.selectionStyle = .none
        cell.textLabel?.text = "???"
        cell.selectionStyle = .none
        return cell
    }()
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellLayout == nil ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLayout!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellLayout![indexPath.row]
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel else { return }
        
        let cell = cellLayout![indexPath.row]
        
        if cell == groupNameCell {
            let groupViewController = GroupViewController(groupId: vm.group.id)
            navigationController?.pushViewController(groupViewController, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc private func userDidPressEditButton() {
        guard viewModel != nil else { return }
        let editorViewController = EventEditorViewController(for: .editing(event: viewModel!.event))
        let editorNavigationController = UINavigationController(rootViewController: editorViewController)
        present(editorNavigationController, animated: true)
    }
    
    @objc private func userDidPressRSVPButton() {
        guard let vm = viewModel else { return }
        setRsvpButton(didRsvp: !vm.event.rsvp)
        rsvpButtonCell.button.isEnabled = false
        networkManager.setRsvp(forEvent: eventId, to: !vm.event.rsvp) { [weak self] error in
            guard error == nil else {
                self?.displayError(message: error!) {
                    self?.setRsvpButton(didRsvp: vm.event.rsvp)
                    self?.rsvpButtonCell.button.isEnabled = true
                }
                return
            }
            self?.rsvpButtonCell.button.isEnabled = true
            self?.viewModel?.event.rsvp = !vm.event.rsvp
        }
    }
    
    // MARK: - Helper Methods
    
    private func performNetworkRequest() {
        let dg = DispatchGroup()
        
        var id: Int?
        // view model components
        var event: Event?
        var group: Group?
        var isGroupMember: Bool?
        
        isLoadingDisplay = true
        
        // >>>>>>>> Get Event
        dg.enter()
        networkManager.read(event: eventId) { [weak self] error, newEvent in
            guard self != nil && self!.responseErrorHandler(error, newEvent) else { dg.leave(); return }
            event = newEvent
            
            // >>>>>>>> Get Group
            dg.enter()
            self!.networkManager.read(group: newEvent!.groupId) { [weak self] error, newGroup in
                guard self != nil && self!.responseErrorHandler(error, newGroup) else { dg.leave(); return }
                group = newGroup
                dg.leave()
            }
            
            // >>>>>>>> Get Group Membership
            dg.enter()
            self!.networkManager.checkSelfIsMember(withinGroup: newEvent!.groupId) { [weak self] error, isNewGroupMember in
                guard self != nil && self!.responseErrorHandler(error, isNewGroupMember) else { dg.leave(); return }
                isGroupMember = isNewGroupMember!["value"]!
                dg.leave()
            }
            
            dg.leave() // for Get Event
        }
        
        // >>>>>>>> Get Self
        dg.enter()
        networkManager.read(profile: nil) { [weak self] error, member in
            guard self != nil && self!.responseErrorHandler(error, member) else { dg.leave(); return }
            id = member!.id
            dg.leave()
        }

        dg.notify(queue: .main) { [weak self] in
            if let id = id, let event = event, let group = group, let isGroupMember = isGroupMember {
                let viewModel = EventViewModel(personalId: id, event: event, group: group, isGroupMember: isGroupMember)
                self?.viewModel = viewModel
                self?.configureSubviews(viewModel: viewModel)
            }
            self?.isLoadingDisplay = false
        }
    }
    
    private func setRsvpButton(didRsvp value: Bool) {
        let buttonTittle = value ? "Cancel RSVP" : "RSVP"
        rsvpButtonCell.button.setTitle(buttonTittle, for: .normal)
    }
    
    private func index(of cell: UITableViewCell) -> IndexPath? {
        guard let arrayIndex = cellLayout?.firstIndex(of: cell) else { return nil }
        return IndexPath(row: arrayIndex, section: 0)
    }
    
    private func configureSubviews(viewModel: EventViewModel) {
        if !viewModel.isGroupMember {
            cellLayout = [groupNameCell, locationCell, whenCell, descriptionCell]
        } else {
            cellLayout = [groupNameCell, rsvpButtonCell, locationCell, whenCell, descriptionCell]
            setRsvpButton(didRsvp: viewModel.event.rsvp)
        }
        
        headerView.label.text = viewModel.event.name
        groupNameCell.textLabel?.text = viewModel.group.title
        whenCell.bottomLabel.text = PreferredDateFormat.describe(viewModel.event.start, using: .format0)!
        descriptionCell.textLabel?.text = viewModel.event.description
        
        PreferredLocationFormat.describe(viewModel.event.location.location, using: .address, { [weak self] components in
            guard self != nil else { return }
            if let addressComponents = components?.first {
                let address = addressComponents.joined(separator: ", ")
                self?.locationCell.bottomLabel.text = address
            }
        })
        
        if (viewModel.personalId == viewModel.group.ownerId) {
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(userDidPressEditButton)), animated: true)
        }
        
        tableView.reloadData()
    }
    
}
