//
//  LoginViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol LoginDisplayLogic: class {
    func displayLogin(viewModel: Login.Login.ViewModel)
}

final class LoginViewController: UIViewController, CustomableView {
    typealias RootView = LoginView
    
    // MARK: - Private Properties
    private let interactor: LoginBusinessLogic
    private var state: Login.ViewControllerState
    
    // MARK: - Object Lifecycle
    init(interactor: LoginBusinessLogic, initialState: Login.ViewControllerState = .initial) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = LoginView(frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.isSecuredScreen = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UserDefaults.standard.isLogined ? goToMain() : nil
    }
    
    // MARK: - Private Methods
    private func requestLogin() {
        guard let login = view().loginTextField.text,
            !login.isEmpty,
            let password = view().passwordTextField.text,
            !password.isEmpty else { return }
        let request = Login.Login.Request(login: login,
                                          password: password)
        interactor.requestLogin(request: request)
    }
    
    private func goToMain() {
        guard let vc = MainBuilder().build() as? MainViewController
            else { fatalError("Couldn't cast to MainViewController!") }
        UserDefaults.standard.isLogined = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .flipHorizontal
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    
    private func goToRegistration() {
        guard let vc = RegistrationBuilder().build() as? RegistrationViewController
            else { fatalError("Couldn't cast to RegistrationViewController!") }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

// MARK: - Display Logic
extension LoginViewController: LoginDisplayLogic {
    func displayLogin(viewModel: Login.Login.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func display(newState: Login.ViewControllerState) {
        state = newState
        switch state {
        case .initial:
            print("initial state")
            
        case .success:
            goToMain()
            
        case let .failure(error):
            switch error {
            case .loginError:
                view().incorrectLogin()
            case .passwordError:
                view().incorrectPassword()
            }
        }
    }
}

// MARK: - View Delegate
extension LoginViewController: LoginViewDelegate {
    func didTapLogin() {
        requestLogin()
    }
    
    func didTapRegister() {
        goToRegistration()
    }
}
