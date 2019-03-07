//
//  FormTableViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

enum SubmissionStatus {
    case waitingForInput
    case submitting
    case submitted
}

typealias Completer = ()->Void

class FormTableViewController: UITableViewController {
    
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let activityIndicatorBarItem = UIBarButtonItem(customView: UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = cancelBarButton
        navigationItem.leftBarButtonItem = doneBarButton
        doneBarButton.target = self
        doneBarButton.action = #selector(doneButtonWasPressed)
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelButtonWasPressed)
        (activityIndicatorBarItem.customView as! UIActivityIndicatorView).style = .gray
    }
    
    var submissionStatus: SubmissionStatus = .waitingForInput {
        didSet {
            switch submissionStatus {
            case .waitingForInput:
                tableView.isUserInteractionEnabled = true
                cancelBarButton.isEnabled = true
                doneBarButton.isEnabled = true
                if navigationItem.leftBarButtonItem == activityIndicatorBarItem {
                    (activityIndicatorBarItem.customView as! UIActivityIndicatorView).stopAnimating()
                    navigationItem.setLeftBarButton(doneBarButton, animated: true)
                }
            case .submitting:
                tableView.isUserInteractionEnabled = false
                cancelBarButton.isEnabled = false
                navigationItem.setLeftBarButton(activityIndicatorBarItem, animated: true)
                (activityIndicatorBarItem.customView as! UIActivityIndicatorView).startAnimating()
            case .submitted:
                if navigationItem.leftBarButtonItem == activityIndicatorBarItem {
                    (activityIndicatorBarItem.customView as! UIActivityIndicatorView).stopAnimating()
                    navigationItem.setLeftBarButton(doneBarButton, animated: true)
                }
                tableView.isUserInteractionEnabled = false
                cancelBarButton.isEnabled = false
                doneBarButton.isEnabled = false
            }
        }
    }
    
    @objc func doneButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func cancelButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    /// Generic function for handling a request returning an error.
    func requestHandler(_ error: String?) {
        guard error == nil else {
            displayError(message: error!) { [weak self] in
                self?.submissionStatus = .waitingForInput
            }
            return
        }
        submissionStatus = .submitted
        dismiss(animated: true)
    }

}
