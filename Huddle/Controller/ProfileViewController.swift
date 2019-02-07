//
//  ProfileViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/30/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    private let networkManager = NetworkManager()
    
    private var member: Member? {
        didSet {
            guard member != nil else { return }
            detailedProfilePhotoView.profileNameLabel.text = member!.name
            detailedProfilePhotoView.locationNameLabel.text = ""
            aboutTableViewCell.textLabel?.text = member!.bio
        }
    }
    
    private enum Section: Int, CaseIterable {
        case about
        case groups
        case logout
    }
    
    // TODO: delete me
    let sampleGroupData = [
        "Group Name 1",
        "Group Name 2",
        "Group Name 3"
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonWasTapped))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .white
        tableView.tableHeaderView = detailedProfilePhotoView
        
        networkManager.readProfile() { [weak self] member, error in
            guard error == nil else {
                print(error! as String)
                return
            }
            self?.member = member
        }
    }
    
    // MARK: - Other Views
    
    let detailedProfilePhotoView: DetailedProfilePhotoView = {
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
        return cell
    }()
    
    private let logoutTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Click to Logout"
        cell.selectionStyle = .none
        return cell
    }()
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .about: return 1
        case .groups: return sampleGroupData.count
        case .logout: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch Section(rawValue: indexPath.section)! {
        case .about:
            cell = aboutTableViewCell
        case .groups:
            cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "TableViewCell")
            cell.textLabel?.text = sampleGroupData[indexPath.row]
        case .logout:
            cell = logoutTableViewCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .about: return "About"
        case .groups: return "Groups"
        case .logout: return "Logout"
        }
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .logout:
            switch indexPath.row {
            case 0: // Logout Cell
                // Remove ALL cookies and then launch the LoginView. This will need to change if we plan on saving any others that shouldn't be removed at log out (which I doubt).
                HTTPCookieStorage.shared.removeCookies(since: Date(timeIntervalSince1970: 0))
                networkManager.isLoggedIn() { result in
                    guard let isLoggedIn = result else {
                        OkPresenter(title: "Network Error", message: "Please check your network settings.", handler: nil).present(in: self)
                        return
                    }
                    if !isLoggedIn {
                        self.present(LoginViewController(), animated: true)
                    }
                }
            default: break
            }
        default: break
        }
        
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)!
        headerView.textLabel?.textColor = UIColor.lightGray
    }
    
    // MARK: - Actions
    
    @objc private func editButtonWasTapped() {
        let editorViewController = ProfileEditorViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: editorViewController)
        present(navigationController, animated: true)
    }
    
    
}
