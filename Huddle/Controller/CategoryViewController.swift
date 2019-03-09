//
//  CategoryViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

class CategoryViewController: UITableViewController, UINavigationControllerDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.allCases.count - 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cat = Category(rawValue: indexPath.row + 1) ?? .none
        cell.textLabel?.text = cat.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        whenSelected?(Category(rawValue: indexPath.row + 1) ?? .none)
        navigationController?.popViewController(animated: true)
    }
    
    var whenSelected: ((Category)->())?
    
}
