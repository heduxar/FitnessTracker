//
//  LoginView.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func didTapLogin()
    func didTapRegister()
}

extension LoginView {
    struct ViewMetrics {
        let backgroundColor = UIColor.systemGray6
        
        let loginPlaceholder = "Enter login"
        let passwordPlaceholder = "Enter password"
        let elementsHeight: CGFloat = 28.0
        
        let loginButtonText = "Login"
        let registerButtonText = "Registration"
        var buttonsCR: CGFloat { elementsHeight / 3 }
    }
}

final class LoginView: UIView {
    
    // MARK: - Private Properties
    private let viewMetrics = ViewMetrics()
    
    // MARK: - Public Properties
    weak var delegate: LoginViewDelegate?
    
    // MARK: - View Properties
    fileprivate(set) lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.placeholder = viewMetrics.loginPlaceholder
        textField.textContentType = .username
        textField.returnKeyType = .next
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addShadow(opacity: 0.16,
                            radius: 8)
        
        return textField
    }()
    
    fileprivate(set) lazy var loginErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemRed
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.0,
                                       weight: .semibold)
        label.text = "Incorrect User"
        label.isHidden = true
        
        return label
    }()
    
    fileprivate(set) lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.placeholder = viewMetrics.passwordPlaceholder
        textField.textContentType = .password
        textField.returnKeyType = .join
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addShadow(opacity: 0.16,
                            radius: 8)
        
        return textField
    }()
    
    fileprivate(set) lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemRed
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.0,
                                       weight: .semibold)
        label.text = "Incorrect password"
        label.isHidden = true
        
        return label
    }()
    
    fileprivate(set) lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewMetrics.loginButtonText,
                        for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.systemTeal
        button.layer.cornerRadius = viewMetrics.buttonsCR
        button.layer.masksToBounds = true
        button.addTarget(self,
                         action: #selector(didTapLogin),
                         for: .touchUpInside)
        button.addShadow(opacity: 0.16,
                         radius: 8)
        return button
    }()
    
    fileprivate(set) lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewMetrics.registerButtonText,
                        for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.systemTeal
        button.layer.cornerRadius = viewMetrics.buttonsCR
        button.addTarget(self,
                         action: #selector(didTapRegister),
                         for: .touchUpInside)
        button.addShadow(opacity: 0.16,
                         radius: 8)
        return button
    }()
    
    // MARK: - Object Lifecycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View actions
    @objc
    private func didTapLogin () {
        delegate?.didTapLogin()
    }
    
    @objc
    private func didTapRegister() {
        delegate?.didTapRegister()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = viewMetrics.backgroundColor
    }
    
    private func addSubviews() {
        addSubview(loginTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
        addSubview(loginErrorLabel)
        addSubview(passwordErrorLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            loginTextField.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            loginTextField.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: 0),
            loginTextField.bottomAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: -viewMetrics.elementsHeight),
            
            loginErrorLabel.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            loginErrorLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: 0),
            loginErrorLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,
                                                 constant: 0),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            passwordTextField.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                       constant: 0),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,
                                                   constant: viewMetrics.elementsHeight),
            
            passwordErrorLabel.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            passwordErrorLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                        constant: 0),
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                    constant: 0),
            
            loginButton.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            loginButton.widthAnchor.constraint(equalToConstant: bounds.width / 3),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                 constant: 0),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                             constant: viewMetrics.elementsHeight),
            
            registerButton.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            registerButton.widthAnchor.constraint(equalToConstant: bounds.width / 3),
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: 0),
            registerButton.centerYAnchor.constraint(equalTo: loginButton.bottomAnchor,
                                                    constant: viewMetrics.elementsHeight)
        ])
    }
    
    // MARK: - Public methods
    func incorrectLogin() {
        loginTextField.shake(duration: 0.3)
        loginErrorLabel.show()
    }
    
    func incorrectPassword() {
        passwordTextField.shake(duration: 0.3)
        passwordErrorLabel.show()
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if loginTextField.text!.isEmpty {
                loginTextField.becomeFirstResponder()
            } else {
                delegate?.didTapLogin()
            }
        default:
            break
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            loginErrorLabel.hide()
        case passwordTextField:
            passwordErrorLabel.hide()
        default:
            break
        }
        return true
    }
}
