//
//  ConfirmationAlert.swift
//  Inbox
//
//  Created by Dan Mitu on 9/10/18.
//  Copyright © 2018 Dan Mitu. All rights reserved.
//

import UIKit

enum Outcome {
    case accepted
    case rejected
}

/// Easier way to show a confirmation alert with an "accept" and "reject" option.
struct ConfirmationPresenter {
    let title: String?
    let message: String?
    let acceptTitle: String
    let rejectTitle: String
    let handler: (Outcome)->Void
    
    func present(in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let rejectAction = UIAlertAction(title: rejectTitle, style: .cancel) { _ in
            self.handler(.rejected)
        }
        
        let acceptAction = UIAlertAction(title: acceptTitle, style: .default) { _ in
            self.handler(.accepted)
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(rejectAction)
        
        viewController.present(alertController, animated: true)
    }
    
}
