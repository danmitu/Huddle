//
//  ResetPasswordViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 1/24/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    var fieldsAreValid: Bool {
        guard let oldPassword = oldPasswordTextField.text,
            let password = newPasswordTextField.text,
            let passwordConfirm = newPasswordConfirmTextField.text
            else { return false }
        guard password.count > 0 && passwordConfirm.count > 0 && oldPassword.count > 0 else { return false }
        guard password == passwordConfirm else { return false }
        return true
    }
    
    // MARK: - Subviews
    
    private let oldPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let newPasswordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm New Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let resetButton: FilledButton = {
        let button = FilledButton()
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(attemptRecover), for: .touchUpInside)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let resetItemsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = UIStackView.spacingUseSystem
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
        [oldPasswordTextField ,newPasswordTextField, newPasswordConfirmTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        resetItemsStackView.addArrangedSubview(oldPasswordTextField)
        resetItemsStackView.addArrangedSubview(newPasswordTextField)
        resetItemsStackView.addArrangedSubview(newPasswordConfirmTextField)
        resetItemsStackView.addArrangedSubview(resetButton)
        self.view.addSubview(resetItemsStackView)
        
        
        NSLayoutConstraint.activate([
            resetItemsStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            oldPasswordTextField.widthAnchor.constraint(equalTo: resetItemsStackView.widthAnchor),
            newPasswordTextField.widthAnchor.constraint(equalTo: resetItemsStackView.widthAnchor),
            newPasswordConfirmTextField.widthAnchor.constraint(equalTo: resetItemsStackView.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: resetItemsStackView.widthAnchor),
            resetItemsStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            resetItemsStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    @objc func textFieldDidChange() {
        resetButton.isEnabled = fieldsAreValid
    }
    
    @objc func goback(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func attemptRecover(sender: UIButton) {
        guard fieldsAreValid else { return }
        
        networkManager.updatePassword(oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!, completion: {
            error in
            guard error == nil else {
                // If there is an error, tell the user.
                DispatchQueue.main.async {
                    OkPresenter(title: "Password Update Failed",
//                                message: "\(error!)",
                                message: "Your old password was incorrect",
                                handler: {}).present(in: self)
                }
                return
            }
            // If an error didn't occur, Tell the user that the account was created and that they now need to log in.
            DispatchQueue.main.async {
                OkPresenter(title: "Password reset succeeded.", message: "", handler: {
                    self.dismiss(animated: true, completion: {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }).present(in: self)
            }
        })
    }
    
}
