//
//  RegisterViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 1/24/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
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
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(attemptRegistry), for: .touchUpInside)
        return button
    }()
    
    private let registerItems: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = UIStackView.spacingUseSystem
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    @objc func attemptRegistry(sender: UIButton) {
        var isPasswordConfirmed: Bool = false
        if (passwordTextField.text == passwordConfirmTextField.text) {
            if (!(passwordTextField.text?.isEmpty)!) {
                isPasswordConfirmed = true
            }
        }
        if (isPasswordConfirmed) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
        registerItems.addArrangedSubview(firstNameTextField)
        registerItems.addArrangedSubview(emailTextField)
        registerItems.addArrangedSubview(passwordTextField)
        registerItems.addArrangedSubview(passwordConfirmTextField)
        registerItems.addArrangedSubview(registerButton)
        self.view.addSubview(registerItems)
        
        
        NSLayoutConstraint.activate([
            registerItems.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            firstNameTextField.widthAnchor.constraint(equalTo: registerItems.widthAnchor),
            emailTextField.widthAnchor.constraint(equalTo: registerItems.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: registerItems.widthAnchor),
            passwordConfirmTextField.widthAnchor.constraint(equalTo: registerItems.widthAnchor),
            registerItems.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            registerItems.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
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
