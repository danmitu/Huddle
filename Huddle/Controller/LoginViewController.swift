//
//  LogInViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 1/23/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    var fieldsAreValid: Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return false }
        guard isValidEmail(testStr: email) else { return false }
        guard password.count > 0 else { return false }
        return true
    }
    
    // MARK: - Subviews
    
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
    
    private let loginButton: FilledButton = {
        let button = FilledButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(attemptLogin), for: .touchUpInside)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let createAccountButton: FilledButton = {
        let button = FilledButton()
        button.setTitle("Create New Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(showRegisterController), for: .touchUpInside)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = FilledButton()
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(showResetController), for: .touchUpInside)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let loginItemsStackView: UIStackView = {
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
        
        [emailTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        loginItemsStackView.addArrangedSubview(emailTextField)
        loginItemsStackView.addArrangedSubview(passwordTextField)
        loginItemsStackView.addArrangedSubview(loginButton)
        loginItemsStackView.addArrangedSubview(createAccountButton)
        // Slack discussion on Jan 30th...
        // We are removing the recover password option for now!
//        loginItems.addArrangedSubview(resetButton)
        self.view.addSubview(loginItemsStackView)
        
        NSLayoutConstraint.activate([
            loginItemsStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            emailTextField.widthAnchor.constraint(equalTo: loginItemsStackView.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginItemsStackView.widthAnchor),
            loginButton.widthAnchor.constraint(equalTo: loginItemsStackView.widthAnchor),
            createAccountButton.widthAnchor.constraint(equalTo: loginItemsStackView.widthAnchor),
            // Slack discussion on Jan 30th...
            // We are removing the recover password option for now!
//            resetButton.widthAnchor.constraint(equalTo: loginItems.widthAnchor),
            loginItemsStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            loginItemsStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - Methods
    
    @objc func textFieldDidChange() {
        loginButton.isEnabled = fieldsAreValid
    }
    
    @objc func showRegisterController() {
        let registerController = RegisterViewController()
        present(registerController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }
    
    @objc func showResetController() {
        let recoverController = ResetPasswordViewController()
        present(recoverController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }
    
    @objc func attemptLogin(sender: UIButton) {
        guard fieldsAreValid else { return }
        
        networkManager.login(email: emailTextField.text!, password: passwordTextField.text!) { error in
            guard error == nil else {
                DispatchQueue.main.async {
                    OkPresenter(title: "Login Failed",
                                message: "\(error!)",
                        handler: {}
                        ).present(in: self)
                }
                UserDefaults.standard.isLoggedIn = false
                return
            }
            
            UserDefaults.standard.isLoggedIn = true
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}
