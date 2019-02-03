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
    
    private let networkManager = NetworkManager()
    
    var fieldsAreValid: Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let passwordConfirm = passwordConfirmTextField.text,
            let fullName = fullNameTextField.text
            else { return false }
        guard isValidEmail(testStr: email) else { return false }
        guard password.count > 0 && passwordConfirm.count > 0 else { return false }
        guard fullName.count > 0 else { return false }
        guard password == passwordConfirm else { return false }
        return true
    }
    
    // MARK: - Subviews
    
    private let fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
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
    
    private let registerButton: FilledButton = {
        let button = FilledButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(attemptCreation), for: .touchUpInside)
        button.backgroundColor = UIColor.preferredTeal
        button.normalBackgroundColor = UIColor.preferredTeal
        button.disabledBackgroundColor = UIColor.disabledGrey
        button.highlightedBackgroundColor = UIColor.preferredTealHighlighted
        button.isEnabled = true
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
    
    private let registerItemsStackView: UIStackView = {
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
        
        [emailTextField, passwordTextField, passwordConfirmTextField, fullNameTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        registerItemsStackView.addArrangedSubview(fullNameTextField)
        registerItemsStackView.addArrangedSubview(emailTextField)
        registerItemsStackView.addArrangedSubview(passwordTextField)
        registerItemsStackView.addArrangedSubview(passwordConfirmTextField)
        registerItemsStackView.addArrangedSubview(registerButton)
        registerItemsStackView.addArrangedSubview(cancelButton)
        self.view.addSubview(registerItemsStackView)
        
        
        NSLayoutConstraint.activate([
            registerItemsStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            fullNameTextField.widthAnchor.constraint(equalTo: registerItemsStackView.widthAnchor),
            emailTextField.widthAnchor.constraint(equalTo: registerItemsStackView.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: registerItemsStackView.widthAnchor),
            passwordConfirmTextField.widthAnchor.constraint(equalTo: registerItemsStackView.widthAnchor),
            registerButton.widthAnchor.constraint(equalTo: registerItemsStackView.widthAnchor),
            cancelButton.widthAnchor.constraint(equalTo: registerItemsStackView.widthAnchor),
            registerItemsStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            registerItemsStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
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
    
    @objc func textFieldDidChange(){
        registerButton.isEnabled = fieldsAreValid
    }
    
    @objc func attemptCreation(sender: UIButton) {
        guard fieldsAreValid else { return }
        
        networkManager.create(email: emailTextField.text!, password: passwordTextField.text!, fullName: fullNameTextField.text!, completion: {
            error in
            guard error == nil else {
                // If there is an error, tell the user.
                DispatchQueue.main.async {
                    OkPresenter(title: "Creation Failed",
                                message: "\(error!)",
                        handler: {}).present(in: self)
                }
                UserDefaults.standard.isLoggedIn = false
                return
            }
            // If an error didn't occur, Tell the user that the account was created and that they now need to log in.
            DispatchQueue.main.async {
                OkPresenter(title: "Account creation succeeded.", message: "Please Log In.", handler: {
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
}
