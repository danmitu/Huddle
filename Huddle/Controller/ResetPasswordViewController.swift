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
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let recoverButton: FilledButton = {
        let button = FilledButton()
        button.setTitle("Recover", for: .normal)
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
    
    private let cancelButton: FilledButton = {
        let button = FilledButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(goback), for: .touchUpInside)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let recoverItems: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = UIStackView.spacingUseSystem
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var fieldsAreValid: Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let passwordConfirm = passwordConfirmTextField.text
            else { return false }
        guard isValidEmail(testStr: email) else { return false }
        guard password.count > 0 && passwordConfirm.count > 0 else { return false }
        guard password == passwordConfirm else { return false }
        return true
    }
    
    @objc func attemptRecover(sender: UIButton) {
        guard fieldsAreValid else { return }
        
        networkManager.update(email: emailTextField.text!, password: passwordTextField.text!, completion: {
            error in
            guard error == nil else {
                // If there is an error, tell the user.
                DispatchQueue.main.async {
                    OkPresenter(title: "Update Failed",
                                message: "\(error!)",
                        handler: {}).present(in: self)
                }
                UserDefaults.standard.isLoggedIn = false
                return
            }
            // If an error didn't occur, Tell the user that the account was created and that they now need to log in.
            DispatchQueue.main.async {
                OkPresenter(title: "Password reset succeeded.", message: "Please Log In.", handler: {
                    self.dismiss(animated: true, completion: {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }).present(in: self)
            }
        })
    }
    
    @objc func goback(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
        [emailTextField, passwordTextField, passwordConfirmTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        recoverItems.addArrangedSubview(emailTextField)
        recoverItems.addArrangedSubview(passwordTextField)
        recoverItems.addArrangedSubview(passwordConfirmTextField)
        recoverItems.addArrangedSubview(recoverButton)
        recoverItems.addArrangedSubview(cancelButton)
        self.view.addSubview(recoverItems)
        
        
        NSLayoutConstraint.activate([
//            cancelButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
//            cancelButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            cancelButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            recoverItems.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            emailTextField.widthAnchor.constraint(equalTo: recoverItems.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: recoverItems.widthAnchor),
            passwordConfirmTextField.widthAnchor.constraint(equalTo: recoverItems.widthAnchor),
            recoverButton.widthAnchor.constraint(equalTo: recoverItems.widthAnchor),
            cancelButton.widthAnchor.constraint(equalTo: recoverItems.widthAnchor),
            recoverItems.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            recoverItems.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func textFieldDidChange() {
        recoverButton.isEnabled = fieldsAreValid
    }
}