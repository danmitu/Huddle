//
//  ProfileViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/30/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    
    var memberID: Int?
    
    private var isPersonalProfile: Bool {
       return memberID == nil
    }
    
    private var showGroups : Bool {
        return isPersonalProfile || member?.publicGroup ?? false
    }
    
    private var showLocation : Bool {
        return isPersonalProfile || member?.publicLocation ?? false
    }
    
    private var member: Member? {
        didSet {
            detailedProfilePhotoView.profileNameLabel.text = member?.name
            detailedProfilePhotoView.locationNameLabel.text = showLocation ? "Location" : ""
            aboutTableViewCell.textLabel?.text = member?.bio
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
        navigationItem.rightBarButtonItem = isPersonalProfile ? UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonWasTapped)) : nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .white
        tableView.tableHeaderView = detailedProfilePhotoView
        
        networkManager.readProfile(id: memberID) { [weak self] member, error in
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
    
    private let logoutButtonCell: ButtonFieldTableViewCell = {
        let cell = ButtonFieldTableViewCell(reuseIdentifier: "ButtonFieldTableViewCell", showSeparators: false)
        cell.button.setTitle("Logout", for: .normal)
//        cell.button.setTitleColor(UIColor.preferredTeal, for: .normal)
        cell.button.addTarget(self, action: #selector(logout), for: .touchUpInside)
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
            return showGroups ? sampleGroupData.count : 0
        case .logout:
            return isPersonalProfile ? 1 : 0
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
            cell = logoutButtonCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .about: return "About"
        case .groups: return showGroups ? "Groups" : ""
        case .logout: return ""
        }
    }
    
    // MARK: Table View Delegate

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
    
    @objc func logout(sender: UIButton) {
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
    }
    
    
}
