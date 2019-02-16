//
//  ResetPasswordViewController.swift
//  Huddle
//
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UITableViewController, UITextFieldDelegate {
    
    private let networkManager = NetworkManager()
    
    private var allFieldsContainText: Bool {
        if oldPasswordCell.textField.text?.count == 0 { return false }
        if newPasswordCell.textField.text?.count == 0 { return false }
        if verifyPasswordCell.textField.text?.count == 0 { return false }
        return true
    }
    
    private let changeBarButton = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(changeButtonWasPressed))
    
    private let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonWasPressed))
    
    private let activityIndicatorBarItem = UIBarButtonItem(customView: UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
    
    // MARK: - Static Cells
    
    private let oldPasswordCell: TextFieldTableViewCell = {
        let cell = TextFieldTableViewCell()
        cell.textField.isSecureTextEntry = true
        cell.textField.placeholder = "enter old password"
        cell.textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        cell.titleLabel.text = "Old"
        cell.selectionStyle = .none
        return cell
    }()
    
    private let newPasswordCell: TextFieldTableViewCell = {
        let cell = TextFieldTableViewCell()
        cell.textField.isSecureTextEntry = true
        cell.textField.placeholder = "enter new password"
        cell.textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        cell.titleLabel.text = "New"
        cell.selectionStyle = .none
        return cell
    }()
    
    private let verifyPasswordCell: TextFieldTableViewCell = {
        let cell = TextFieldTableViewCell()
        cell.textField.isSecureTextEntry = true
        cell.textField.placeholder = "re-enter new password"
        cell.textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        cell.titleLabel.text = "Verify"
        cell.selectionStyle = .none
        return cell
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Change Password"
        oldPasswordCell.textField.delegate = self
        newPasswordCell.textField.delegate = self
        verifyPasswordCell.textField.delegate = self
        navigationItem.rightBarButtonItem = changeBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
        cancelBarButton.isEnabled = true
        changeBarButton.isEnabled = false
        
        // cannot be done at initialization 😢
        changeBarButton.target = self
        changeBarButton.action = #selector(changeButtonWasPressed)
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelButtonWasPressed)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return oldPasswordCell
        case 1: return newPasswordCell
        case 2: return verifyPasswordCell
        default: fatalError("Unreachable")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        assert(section == 0)
        return nil // TODO: Password requirements go here.
    }
    
    
    // MARK: - UITextFieldDelegate
    
    @objc func textFieldEditingDidChange(_ textField: UITextField) {
        changeBarButton.isEnabled = allFieldsContainText
    }
    
    // MARK: - Actions
    
    @objc func changeButtonWasPressed() {
        guard newPasswordCell.textField.text == verifyPasswordCell.textField.text else {
            OkPresenter(title: "Passwords do not match.",
                        message: "Your entered passwords do not match. Please try again.",
                        handler: {}).present(in: self)
            return
        }
        
        setButtons(for: .submitting)
        
        networkManager.updateMemberCredentials(oldPassword: oldPasswordCell.textField.text!, newPassword: newPasswordCell.textField.text!, completion: { [weak self] error in
            guard self != nil else { return }
            self!.setButtons(for: .waitingForInput)
            guard error == nil else {
                self!.navigationItem.setRightBarButton(self!.changeBarButton, animated: true)
                OkPresenter(title: "Password Update Failed",
                            message: "Your old password was incorrect.",
                            handler: {}).present(in: self!)
                return
            }
            self?.dismiss(animated: true)
        })
        
    }
    
    @objc func cancelButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Methods
    
    private func setButtons(for status: SubmissionStatus) {
        switch status {
        case .waitingForInput:
            cancelBarButton.isEnabled = true
            changeBarButton.isEnabled = true
            newPasswordCell.textField.isEnabled = true
            oldPasswordCell.textField.isEnabled = true
            verifyPasswordCell.textField.isEnabled = true
            navigationItem.setRightBarButton(changeBarButton, animated: true)
            (activityIndicatorBarItem.customView as! UIActivityIndicatorView).stopAnimating()
        case .submitting:
            newPasswordCell.textField.isEnabled = false
            oldPasswordCell.textField.isEnabled = false
            verifyPasswordCell.textField.isEnabled = false
            cancelBarButton.isEnabled = false
            navigationItem.setRightBarButton(activityIndicatorBarItem, animated: true)
            (activityIndicatorBarItem.customView as! UIActivityIndicatorView).startAnimating()
        default: break
        }
    }

}
