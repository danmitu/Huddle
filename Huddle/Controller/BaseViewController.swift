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
        vc.tabBarItem = UITabBarItem(title: "Explore",
                                     image: DrawCode.imageOfExploreTabIcon(isSelected: false),
                                     selectedImage: DrawCode.imageOfExploreTabIcon(isSelected: true))
        return vc
    }()
    
    private let calendarViewController: CalendarViewController = {
        let vc = CalendarViewController()
        vc.tabBarItem = UITabBarItem(title: "Calendar",
                                     image: DrawCode.imageOfCalendarTabIcon(isSelected: false),
                                     selectedImage: DrawCode.imageOfCalendarTabIcon(isSelected: true))
        return vc
    }()
    
    private let userViewController: UIViewController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Profile",
                                     image: DrawCode.imageOfUserTabIcon(isSelected: false),
                                     selectedImage: DrawCode.imageOfUserTabIcon(isSelected: true))
        return vc
    }()
        
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // set the order for the view controllers, but wrap them in a navigation controller
        self.viewControllers = [exploreViewController, calendarViewController, userViewController].map {
            return UINavigationController(rootViewController: $0)
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabUnselected], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabSelected], for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.standard.isLoggedIn {
            let loginViewController = LoginViewController()
            present(loginViewController, animated: false)
        }
    }
}
