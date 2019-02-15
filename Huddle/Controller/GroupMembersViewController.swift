//
//  GroupMembersViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/14/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class GroupMembersViewController: UITableViewController {
    
    // TODO: delete me
    
    var memberIDs: [Int]
    
    init(memberIDsToShow: [Int]) {
        memberIDs = memberIDsToShow
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        memberIDs = []
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(GroupMembersViewController.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberIDs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let member = memberIDs[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Member #\(member)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileViewController = ProfileViewController(style: .grouped)
        profileViewController.publicMemberId = memberIDs[indexPath.row]
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

// TODO: delete me
//fileprivate struct Event {
//    let name: String
//    let groupName: String
//    let date: Date
//    let location: String
//}
