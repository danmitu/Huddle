//
//  AsyncTableViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 3/1/19.
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
