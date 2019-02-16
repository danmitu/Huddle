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
    
    let networkManager = NetworkManager()
    
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
    
    private let profileViewController: ProfileViewController = {
        let vc = ProfileViewController()
        vc.tabBarItem = UITabBarItem(title: "Profile",
                                     image: DrawCode.imageOfUserTabIcon(isSelected: false),
                                     selectedImage: DrawCode.imageOfUserTabIcon(isSelected: true))
        return vc
    }()
    
    // Temporary View for testing a different users profile page
    private let testOutsideProfileViewController: ProfileViewController = {
        let vc = ProfileViewController(profileOwnerId: 2)
        vc.tabBarItem = UITabBarItem(title: "Test Profile",
                                     image: DrawCode.imageOfUserTabIcon(isSelected: false),
                                     selectedImage: DrawCode.imageOfUserTabIcon(isSelected: true))
        return vc
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // set the order for the view controllers, but wrap them in a navigation controller
        self.viewControllers = [exploreViewController, calendarViewController, profileViewController].map {
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
        networkManager.checkLogin() { result in
            guard let isLoggedIn = result else {
                OkPresenter(title: "Network Error", message: "Please check your network settings.", handler: nil).present(in: self)
                return
            }
            if !isLoggedIn {
                self.present(LoginViewController(), animated: true)
            }
        }
    }
}
