//
//  DestructiveConfirmationPresenter.swift
//  Inbox
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

/// Easier way to show a destructive confirmation alert with an accept and reject option.
struct DestructiveConfirmationPresenter {
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
        
        let acceptAction = UIAlertAction(title: acceptTitle, style: .destructive) { _ in
            self.handler(.accepted)
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(rejectAction)
        
        viewController.present(alertController, animated: true)
    }
    
}
