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
    func didTapPickAvatar()
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
        
        let titleLabelInsets = UIEdgeInsets(top: 25.0,
                                            left: 16.0,
                                            bottom: 50.0,
                                            right: 16.0)
        
        let avatarPlaceholderImageName = "avatar_placeholder"
        let avatarTintColor = UIColor.systemGray2
        
        let photoIconImageName = "icon_camera"
    }
}

final class RegistrationView: UIView {
    
    // MARK: - Private Properties
    private let viewMetrics = ViewMetrics()
    private let gestureAvatarPicker = UIGestureRecognizer()
    
    // MARK: - Public Properties
    weak var delegate: RegistrationViewDelegate?
    
    // MARK: - View Properties
    fileprivate(set) lazy var avatarPicker: UIButton = {
        let avatarPicker = UIButton()
        avatarPicker.translatesAutoresizingMaskIntoConstraints = false
        avatarPicker.addTarget(self,
                               action: #selector(didTapPickAvatar),
                               for: .touchUpInside)
        avatarPicker.setBackgroundImage(UIImage(named: viewMetrics.avatarPlaceholderImageName),
                                        for: .normal)
        avatarPicker.tintColor = viewMetrics.avatarTintColor
        
        return avatarPicker
    }()
    
    fileprivate(set) lazy var photoIcon: UIImageView = {
        let photoIcon = UIImageView(image: UIImage(named: viewMetrics.photoIconImageName))
        photoIcon.translatesAutoresizingMaskIntoConstraints = false
        photoIcon.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.5)
        photoIcon.tintColor = UIColor.systemGray
        
        return photoIcon
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
    
    @objc
    private func didTapPickAvatar() {
        delegate?.didTapPickAvatar()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = viewMetrics.backgroundColor
        avatarPicker.layer.cornerRadius = avatarPicker.frame.height / 2
        avatarPicker.layer.masksToBounds = true
        photoIcon.layer.cornerRadius = photoIcon.frame.height / 2
        photoIcon.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        addSubview(avatarPicker)
        avatarPicker.addSubview(photoIcon)
        addSubview(loginTextField)
        addSubview(loginErrorLabel)
        addSubview(passwordTextField)
        addSubview(passwordErrorLabel)
        addSubview(registerButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            avatarPicker.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            avatarPicker.heightAnchor.constraint(equalTo: avatarPicker.widthAnchor, multiplier: 1),
            avatarPicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            photoIcon.widthAnchor.constraint(equalTo: avatarPicker.widthAnchor, multiplier: 0.5),
            photoIcon.heightAnchor.constraint(equalTo: avatarPicker.heightAnchor, multiplier: 0.5),
            photoIcon.centerXAnchor.constraint(equalTo: avatarPicker.centerXAnchor),
            photoIcon.centerYAnchor.constraint(equalTo: avatarPicker.centerYAnchor),
            
            loginTextField.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            loginTextField.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: 0),
            loginTextField.topAnchor.constraint(equalTo: avatarPicker.bottomAnchor,
                                                constant: viewMetrics.titleLabelInsets.top),
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
            
            passwordErrorLabel.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            passwordErrorLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                        constant: 0),
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                    constant: 0),
            
            registerButton.heightAnchor.constraint(equalToConstant: viewMetrics.elementsHeight),
            registerButton.widthAnchor.constraint(equalToConstant: bounds.width / 3),
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: 0),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                    constant: viewMetrics.elementsHeight)
        ])
    }
    
    // MARK: - Public methods
    func showLoginError(text: String) {
        loginErrorLabel.text = text
        loginErrorLabel.show()
        loginTextField.shake(duration: 0.3)
        loginTextField.layer.borderWidth = 1.3
        loginTextField.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    func showPasswordError(text: String) {
        passwordErrorLabel.text = text
        passwordErrorLabel.show()
        passwordTextField.shake(duration: 0.3)
        passwordTextField.layer.borderWidth = 1.3
        passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
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
            loginTextField.layer.borderWidth = 0
            loginTextField.layer.borderColor = nil
        case passwordTextField:
            passwordErrorLabel.hide()
            passwordTextField.layer.borderWidth = 0
            passwordTextField.layer.borderColor = nil
        default:
            break
        }
        return true
    }
}
