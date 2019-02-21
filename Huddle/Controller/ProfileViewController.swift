//
//  ProfileViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/30/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    /// - Parameter profileOwnerId: Needed if this represents a public profile. `nil` by default meaning this is the user's profile.
    init(profileOwnerId: Int? = nil) {
        
        if let profileOwnerId = profileOwnerId {
            self.owner = Owner.publicProfile(id: profileOwnerId)
        } else {
            self.owner = Owner.personalProfile
        }
        
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    private enum Owner {
        case personalProfile
        case publicProfile(id: Int)
    }
    
    private let owner: Owner
        
    private var member: Member? {
        didSet {
            tableView.beginUpdates()
            detailedProfilePhotoView.profileNameLabel.text = member?.name
            detailedProfilePhotoView.locationNameLabel.text = member?.homeLocation?.name ?? ""
            aboutTableViewCell.textLabel?.text = member?.bio
            detailedProfilePhotoView.profilePhotoImageView.image = member?.profilePhoto ?? UIImage(named: "User Profile Placeholder")!
            tableView.endUpdates()
        }
    }

    private var joinedGroups = [Group]() {
        didSet {
            self.tableView.reloadSections(IndexSet(integer: Section.groups.rawValue), with: UITableView.RowAnimation.automatic)
        }
    }
    
    private enum Section: Int, CaseIterable {
        case about
        case groups
        case logout
    }    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performNetworkRequest()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)

        switch owner {
        case .personalProfile:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonWasTapped))
        case .publicProfile:
            break
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .white
        tableView.tableHeaderView = detailedProfilePhotoView
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isBeingPresented {
            performNetworkRequest()
        }
    }
    
    // MARK: - Other Views
    
    private let detailedProfilePhotoView: DetailedProfilePhotoView = {
        let view = Bundle.main.loadNibNamed("DetailedProfilePhotoView", owner: self, options: nil)![0] as! DetailedProfilePhotoView
        view.autoresizingMask = .flexibleWidth
        view.translatesAutoresizingMaskIntoConstraints = true
        view.profilePhotoImageView.maskCircle(withImage: UIImage(named: "User Profile Placeholder")!)
        view.profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
        view.profilePhotoImageView.layer.borderWidth = 4
        return view
    }()
    
    // MARK: - Static Cells
    
    private let aboutTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.selectionStyle = .none
        return cell
    }()
    
    private let logoutButtonCell: FilledButtonTableViewCell = {
        let cell = FilledButtonTableViewCell(reuseIdentifier: "ButtonFieldTableViewCell", showSeparators: false)
        cell.button.setTitle("Logout", for: .normal)
        cell.button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        cell.selectionStyle = .none
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
        case .groups:
            return joinedGroups.count
        case .logout:
            switch owner {
            case .personalProfile: return 1
            case .publicProfile: return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch Section(rawValue: indexPath.section)! {
        case .about:
            cell = aboutTableViewCell
        case .groups:
            cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "TableViewCell")
            cell.textLabel?.text = joinedGroups[indexPath.row].title
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        case .logout:
            cell = logoutButtonCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .about: return "About"
        case .groups: return "Groups"
        case .logout: return ""
        }
    }
    
    // MARK: Table View Delegate

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        headerView.textLabel?.textColor = UIColor.lightGray
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Section(rawValue: indexPath.section) == .groups {
            let groupViewController = GroupViewController(groupId: joinedGroups[indexPath.row].id)
            navigationController?.pushViewController(groupViewController, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc private func editButtonWasTapped() {
        let editorViewController = ProfileEditorViewController(style: .grouped)
        editorViewController.member = self.member
        editorViewController.joinedGroups = self.joinedGroups
        let navigationController = UINavigationController(rootViewController: editorViewController)
        present(navigationController, animated: true)
    }
    
    @objc func logout(sender: UIButton) {
        networkManager.logout() { [weak self] error in
            guard error == nil else {
                if self != nil {
                    OkPresenter(title: "Network Error", message: error, handler: nil).present(in: self!)
                }
                return
            }
            HTTPCookieStorage.shared.removeCookies(since: Date(timeIntervalSince1970: 0))
            self?.present(LoginViewController(), animated: true)
        }
    }
    
    @objc private func refresh() {
        performNetworkRequest() { [weak self] in
            self?.refreshControl!.endRefreshing()
        }
    }
    
    // MARK: - Methods
    
    private func performNetworkRequest(completion: (()->())? = nil) {
        guard case .personalProfile = owner else { return }
        
        let id: Int?
        switch owner {
        case .personalProfile: id = nil
        case .publicProfile(id: let publicId): id = publicId
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        networkManager.read(profile: id) { member, error in
            if let error = error { print(error) }
            self.member = member
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.getGroups(forMember: id) { groups, error in
            if let error = error { print(error) }
            self.joinedGroups = groups ?? [Group]()
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.get(profileImageForMember: id) { [weak self] image, error in
            if let error = error { print(error) }
            self?.member?.profilePhoto = image
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    
    
}
