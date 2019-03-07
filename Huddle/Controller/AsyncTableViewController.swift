//
//  AsyncTableViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
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
    
    /// Displays an error with the error string if it exists, or if the data is nil. Then it pops the current view controllers.
    /// Returns true if everything is good to go. 
    func responseErrorHandler<T>(_ error: String?, _ data: T?) -> Bool {
        if let error = error {
            displayError(message: error) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return false
        }
        guard data != nil else {
            displayError(message: "There was an error loading this page.") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return false
        }
        return true
    }
}
