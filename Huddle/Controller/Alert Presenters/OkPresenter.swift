//
//  OkPresenter.swift
//  Inbox
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

/// Easier way to show a confirmation alert with an "OK" option.
struct OkPresenter {
    let title: String?
    let message: String?
    let handler: (()->Void)?
    
    func present(in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.handler?()
        }
        alertController.addAction(acceptAction)
        viewController.present(alertController, animated: true)
    }
}
