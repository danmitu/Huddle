//
//  BaseViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/18/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class BaseViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let exploreViewController: UIViewController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return vc
    }()
    
    private let calendarViewController: UIViewController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        return vc
    }()
    
    private let userViewController: UIViewController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        return vc
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [exploreViewController, calendarViewController, userViewController].map {
            return UINavigationController(rootViewController: $0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
