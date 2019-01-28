//
//  OkPresenter.swift
//  Inbox
//
//  Created by Dan Mitu on 9/11/18.
//  Copyright © 2018 Dan Mitu. All rights reserved.
//

import UIKit

/// Easier way to show a confirmation alert with an "OK" option.
struct OkPresenter {
    let title: String?
    let message: String?
    let handler: ()->Void
    
    func present(in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.handler()
        }
        alertController.addAction(acceptAction)
        viewController.present(alertController, animated: true)
    }
}
