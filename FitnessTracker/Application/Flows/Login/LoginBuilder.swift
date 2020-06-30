//
//  LoginBuilder.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

final class LoginBuilder {
    
    // MARK: - Private Properties
    private var initialState: Login.ViewControllerState?
    
    // MARK: - Public Methods
    func set(initialState: Login.ViewControllerState) -> LoginBuilder {
        self.initialState = initialState
        return self
    }
    
    func build() -> UIViewController {
        let presenter = LoginPresenter()
        let interactor = LoginInteractor(presenter: presenter)
        let controller = LoginViewController(interactor: interactor)
        
        presenter.viewController = controller
        return controller
    }
}
