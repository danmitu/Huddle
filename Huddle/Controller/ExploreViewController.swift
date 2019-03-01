//
//  ExploreViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 2/27/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class AsyncTableViewController: UITableViewController {
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = activityIndicatorView
    }
    
    var isLoadingDisplay: Bool = false {
        didSet {
            if isLoadingDisplay {
                tableView.separatorStyle = .none
                activityIndicatorView.startAnimating()
            } else {
                tableView.separatorStyle = .singleLine
                activityIndicatorView.stopAnimating()
            }
        }
    }

}

class ExploreViewController: AsyncTableViewController {

    private let networkManager = NetworkManager()
    
    private var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Pick an Interest"
        isLoadingDisplay = true
        networkManager.getAllCategories(completion: { categories, error in
            self.categories = categories!.map({ Category(rawValue: $0)! })
            self.isLoadingDisplay = false
            self.tableView.reloadData()
        })
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.detailTextLabel?.text = categories[indexPath.row].description
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
