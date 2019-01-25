//
//  MainNavigationController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 1/23/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if isLoggedIn() {
            let homeController = BaseViewController()
            viewControllers = [homeController]
        } else {
            // Launch the Login page
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    private func isLoggedIn() -> Bool {
        // Need to update this to check for previous log in
        return false
    }
    
    @objc func showLoginController() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }
}
