//
//  ProfileViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/30/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ProfileViewController: AsyncTableViewController {
    
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
            guard member != nil else { return }

            detailedProfilePhotoView.profileNameLabel.text = member!.name
            
            switch owner {
            case .publicProfile:
                
                if member!.publicLocation {
                    detailedProfilePhotoView.locationNameLabel.text = member?.homeLocation!.name
                } else {
                    detailedProfilePhotoView.locationNameLabel.text = ""
                }
            case .personalProfile:
                detailedProfilePhotoView.locationNameLabel.text = member?.homeLocation!.name
            }
//            if member!.publicLocation {
//                detailedProfilePhotoView.locationNameLabel.text = member?.homeLocation!.name
//            } else {
//                detailedProfilePhotoView.locationNameLabel.text = ""
//            }
            
            aboutTableViewCell.textLabel?.text = member!.bio
            detailedProfilePhotoView.profilePhotoImageView.image = member!.profilePhoto ?? UIImage(named: "User Profile Placeholder")!
        }
    }

    private var joinedGroups = [Group]() {
        didSet {
            self.tableView.reloadSections(IndexSet(integer: Section.groups.rawValue), with: UITableView.RowAnimation.automatic)
        }
    }
    
    private var numberGroups: Int {
        if let member = member {
            switch owner {
            case .personalProfile:
                return joinedGroups.count
            case .publicProfile:
                return member.publicGroup ? joinedGroups.count : 0
            }
//            return member.publicGroup ? joinedGroups.count : 0
        } else {
            return 0
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
            return numberGroups
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
        let id: Int?
        switch owner {
        case .personalProfile: id = nil
        case .publicProfile(id: let publicId): id = publicId
        }
        
        // temp values
        var tMember: Member?
        var tGroups: [Group]?
        var tImage: UIImage?
        
        let dg = DispatchGroup()
        dg.enter()
        networkManager.read(profile: id) { [weak self] error, member in
            guard self != nil && self!.responseErrorHandler(error, member) else { return }
            tMember = member
            dg.leave()
        }
        
        dg.enter()
        networkManager.getGroups(forMember: id) { [weak self] error, groups in
            guard self != nil && self!.responseErrorHandler(error, groups) else { return }
            tGroups = groups
            dg.leave()
        }
        
        dg.enter()
        networkManager.get(profileImageForMember: id) { [weak self] error, image in
            guard self != nil else { return }
            tImage = image
            dg.leave()
        }
        
        dg.notify(queue: .main) { [weak self] in
            guard self != nil else { return }
            
            if let newMember = tMember {
                self?.member = newMember
            }
            if let groups = tGroups {
                self?.joinedGroups = groups
            }
            if let image = tImage {
                self?.member?.profilePhoto = image
            }
            completion?()
        }
    }
    
}
