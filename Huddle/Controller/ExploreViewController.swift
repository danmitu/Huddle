//
//  ExploreViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

class ExploreViewController: AsyncTableViewController {

    private let networkManager = NetworkManager()
    
    private var categories: [Category]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Group", style: .plain, target: self, action: #selector(launchNewGroup))
        self.navigationItem.title = "Pick an Interest"
        isLoadingDisplay = true
        networkManager.getAllCategories() { [weak self] error, categories in
            guard self != nil && self!.responseErrorHandler(error, categories) else { return }
            self!.categories = categories!.flatMap({ $0 }).map({ Category(rawValue: $0.value)! })
            self!.isLoadingDisplay = false
            self!.tableView.reloadData()
        }
    }
    
    @objc private func launchNewGroup() {
        let groupVc = GroupEditorViewController(for: .creating)
        let navCon = UINavigationController(rootViewController: groupVc)
        present(navCon, animated: true)
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
