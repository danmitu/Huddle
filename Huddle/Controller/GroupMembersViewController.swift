//
//  GroupMembersViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/14/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class GroupMembersViewController: UITableViewController {

    private var members = [Member]()
    
    private let networkManager = NetworkManager()
    
    private let groupId: Int
    
    init(groupId: Int) {
        self.groupId = groupId
        super.init(style: .plain)
        performNetworkRequest()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) is not supported") }
    
    private func performNetworkRequest() {
        networkManager.getGroupMembers(for: groupId) { [weak self] members, error in
            guard error == nil else {
                self?.displayError(message: error!) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                return
            }
            DispatchQueue.main.async {
                self?.members = members!
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let member = members[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = member.name ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileViewController = ProfileViewController(profileOwnerId: members[indexPath.row].id)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
