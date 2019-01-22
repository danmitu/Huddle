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
    
    // Colors for tab text. I wish I could put it somewhere else.
    private let selectedColor = UIColor(red: 0.000, green: 0.478, blue: 0.980, alpha: 1.000)
    private let unselectedColor = UIColor(red: 0.624, green: 0.624, blue: 0.624, alpha: 1.000)
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // set the order for the view controllers, but wrap them in a navigation controller
        self.viewControllers = [exploreViewController, calendarViewController, userViewController].map {
            return UINavigationController(rootViewController: $0)
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
