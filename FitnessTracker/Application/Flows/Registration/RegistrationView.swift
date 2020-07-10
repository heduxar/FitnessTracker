//
//  RegistrationView.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationViewDelegate: class {
    func didTapRegister()
}

extension RegistrationView {
    struct ViewMetrics {
        let backgroundColor = UIColor.systemGray6
        
        let registrationLabel = "Registration a new user"
        let loginPlaceholder = "Fill your username"
        let passwordPlaceholder = "Fill your password"
        let elementsHeight: CGFloat = 28.0
        
        let registerButtonText = "Finish"
        var registerButtonCR: CGFloat { elementsHeight / 3 }
        
        let titleLabelInsets = UIEdgeInsets(top: 50.0,
                                            left: 16.0,
                                            bottom: 50.0,
                                            right: 16.0)
    }
}

final class RegistrationView: UIView {
    
    // MARK: - Private Properties
    private let viewMetrics = ViewMetrics()
    
    // MARK: - Public Properties
    weak var delegate: RegistrationViewDelegate?
    
    // MARK: - View Properties
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.text = viewMetrics.registrationLabel
        label.font = UIFont.systemFont(ofSize: 25,
                                       weight: .heavy)
        return label
    }()
    
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
        label.text = "User exists"
        label.isHidden = true
        
        return label
    }()
    
    fileprivate(set) lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
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
    
    fileprivate(set) lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewMetrics.registerButtonText,
                        for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.systemTeal
        button.layer.cornerRadius = viewMetrics.registerButtonCR
        button.addTarget(self,
                         action: #selector(didTapRegister),
                         for: .touchUpInside)
        button.addShadow(opacity: 0.16,
                         radius: 8)
        return button
    }()
    
    // MARK: - Object Lifecycle
    override init(frame: CGRect = CGRect.zero) {
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
    private func didTapRegister() {
        delegate?.didTapRegister()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = viewMetrics.backgroundColor
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(loginTextField)
        addSubview(loginErrorLabel)
        addSubview(passwordTextField)
        addSubview(registerButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                constant: 0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: viewMetrics.titleLabelInsets.top),
            titleLabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor,
                                               constant: -viewMetrics.titleLabelInsets.bottom),
            
            loginTextField.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            loginTextField.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            loginTextField.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor,
                                                    constant: 0),
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                constant: viewMetrics.titleLabelInsets.bottom),
            loginTextField.bottomAnchor.constraint(equalTo: topAnchor,
                                                   constant: bounds.height / 3),
            
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
            
            registerButton.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            registerButton.widthAnchor.constraint(equalToConstant: bounds.width / 3),
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: 0),
            registerButton.centerYAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                    constant: viewMetrics.elementsHeight)
        ])
    }
    
    // MARK: - Public methods
    func showLoginExists() {
        loginErrorLabel.show()
        loginTextField.shake(duration: 0.3)
    }
}

extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if loginTextField.text!.isEmpty {
                loginTextField.becomeFirstResponder()
            } else {
                delegate?.didTapRegister()
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
        default:
            break
        }
        return true
    }
}
