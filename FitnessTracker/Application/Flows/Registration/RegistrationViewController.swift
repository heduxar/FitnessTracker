//
//  RegistrationViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationDisplayLogic: class {
    func displayCheckUserName(viewModel: Registration.CheckUserName.ViewModel)
    func displayRegisterUser(viewModel: Registration.RegistrationUser.ViewModel)
}

final class RegistrationViewController: UIViewController, CustomableView {
    typealias RootView = RegistrationView
    
    // MARK: - Private Properties
    private let interactor: RegistrationBusinessLogic
    private var state: Registration.ViewControllerState
    
    // MARK: - Object Lifecycle
    init(interactor: RegistrationBusinessLogic, initialState: Registration.ViewControllerState = .initial) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = RegistrationView(frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.isSecuredScreen = true
        configureNavController()
    }
    
    // MARK: - Private Methods
    private func checkUser() {
        guard let login = view().loginTextField.text else { return }
        let request = Registration.CheckUserName.Request(login: login)
        interactor.checkUser(request: request)
    }
    
    private func registerUser() {
        guard let login = view().loginTextField.text,
            let password = view().passwordTextField.text else { return }
        let request = Registration.RegistrationUser.Request(login: login,
                                                            password: password)
        interactor.registerUser(request: request)
    }
    
    private func configureNavController() {
        title = "Registration"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func success() {
        UserDefaults.standard.isLogined = true
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Display Logic
extension RegistrationViewController: RegistrationDisplayLogic {
    func displayCheckUserName(viewModel: Registration.CheckUserName.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func displayRegisterUser(viewModel: Registration.RegistrationUser.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func display(newState: Registration.ViewControllerState) {
        state = newState
        switch state {
        case .initial:
            break
        case .success:
            success()
        case .registration:
            registerUser()
        case .failure(let error):
            switch error {
            case .userExists:
                view().showLoginExists()
            case .somethingGoneWrong:
                print("some error")
            }
        }
    }
}

// MARK: - View Delegate
extension RegistrationViewController: RegistrationViewDelegate {
    func didTapRegister() {
        checkUser()
    }
}
