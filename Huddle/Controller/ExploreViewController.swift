//
//  ExploreViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 2/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ExploreViewController: AsyncTableViewController {

    private let networkManager = NetworkManager()
    
    private var categories: [Category]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Pick an Interest"
        isLoadingDisplay = true
        networkManager.getAllCategories() { [weak self] categories, error in
            guard self != nil else { return }
            self!.categories = categories!.map({ Category(rawValue: $0)! })
            self!.isLoadingDisplay = false
            self!.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories == nil ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.detailTextLabel?.text = categories[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupViewController = SearchGroupViewController(category: categories[indexPath.row].rawValue)
        navigationController!.pushViewController(groupViewController, animated: true)
    }
    
}
