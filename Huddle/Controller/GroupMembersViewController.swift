//
//  GroupMembersViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

class GroupMembersViewController: AsyncTableViewController {

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
        networkManager.getGroupMembers(for: groupId) { [weak self] error, members in
            guard self != nil && self!.responseErrorHandler(error, members) else { return }
            DispatchQueue.main.async {
                self!.members = members!
                self!.tableView.reloadData()
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
