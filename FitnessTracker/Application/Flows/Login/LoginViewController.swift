//
//  LoginViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol LoginDisplayLogic: class {
    func displaySomething(viewModel: Login.Something.ViewModel)
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
        doSomething()
    }
    
    // MARK: - Private Methods
    private func doSomething() {
        let request = Login.Something.Request()
        interactor.doSomething(request: request)
    }
}

// MARK: - Display Logic
extension LoginViewController: LoginDisplayLogic {
    func displaySomething(viewModel: Login.Something.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func display(newState: Login.ViewControllerState) {
        state = newState
        switch state {
        case .initial:
            print("initial state")
        case let .failure(error):
            print("error \(error)")
        case let .result(items):
            print("result: \(items)")
        case .emptyResult:
            print("empty result")
        }
    }
}

// MARK: - View Delegate
extension LoginViewController: LoginViewDelegate {
    func didTapLogin() {
        print(#function)
    }
    
    func didTapRegister() {
        print(#function)
    }
    
    
}
