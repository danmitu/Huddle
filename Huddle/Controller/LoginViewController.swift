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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(attemptLogin), for: .touchUpInside)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create New Account", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(showRegisterController), for: .touchUpInside)
        return button
    }()
    
    private let recoverButton: UIButton = {
        let button = UIButton()
        button.setTitle("Recover Password", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(showRecoverController), for: .touchUpInside)
        return button
    }()
    
    private let loginItems: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = UIStackView.spacingUseSystem
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    @objc func showRegisterController() {
        let registerController = RegisterViewController()
        present(registerController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }
    
    @objc func showRecoverController() {
        let recoverController = RecoverPasswordViewController()
        present(recoverController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }
    
    @objc func attemptLogin(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        networkManager.login(email: email, password: password) { error in
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
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
        loginItems.addArrangedSubview(emailTextField)
        loginItems.addArrangedSubview(passwordTextField)
        loginItems.addArrangedSubview(loginButton)
        loginItems.addArrangedSubview(createAccountButton)
        loginItems.addArrangedSubview(recoverButton)
        self.view.addSubview(loginItems)
        
        
        NSLayoutConstraint.activate([
            loginItems.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            emailTextField.widthAnchor.constraint(equalTo: loginItems.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginItems.widthAnchor),
            loginItems.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            loginItems.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
