//
//  SearchGroupViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/26/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class SearchGroupViewController: UITableViewController {
    
    private let networkManager = NetworkManager()
    
    var category:Category
    var radius:Int
    
    class groupData {
        var groupName: String
        var distance: Float
        var description: String
        var id: Int
        init(groupName: String, distance: Float, description: String, id: Int) {
            self.groupName = groupName
            self.distance = distance
            self.description = description
            self.id = id
        }
    }
    
    
    private var groupData = [Group](){
        didSet {
            self.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.automatic)
            
        }
    }
    
    // MARK: - View Lifecycle
    
    init(category:Int, radius: Int) {
        self.category = Category(rawValue: category) ?? .other
        self.radius = radius
        super.init(style: .plain)
        self.navigationItem.title = self.category.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        performNetworkRequest()
        super.viewDidLoad()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupTableViewCell")
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isBeingPresented {
            performNetworkRequest()
        }
    }
    
    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as! GroupTableViewCell
        let group = self.groupData[indexPath.row] //allGroupData[indexPath.row]
        cell.set(groupName: group.title ?? "", distance: group.distance ?? 0.0, description: group.description ?? "", id: group.id)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupViewController = GroupViewController(groupId: self.groupData[indexPath.row].id)
        navigationController?.pushViewController(groupViewController, animated: true)
    }
    
    @objc private func refresh() {
        performNetworkRequest() { [weak self] in
            self?.refreshControl!.endRefreshing()
        }
    }
    
    
    private func performNetworkRequest(completion: (()->())? = nil) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        networkManager.searchForGroups(id: self.category.rawValue, radius: 999999) { groups, error in
            if let error = error { print(error) }
            self.groupData = groups ?? [Group]()
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
}
