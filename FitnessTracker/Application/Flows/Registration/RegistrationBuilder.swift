//
//  RegistrationBuilder.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

final class RegistrationBuilder {
    
    // MARK: - Private Properties
    private var initialState: Registration.ViewControllerState?
    
    // MARK: - Public Methods
    func set(initialState: Registration.ViewControllerState) -> RegistrationBuilder {
        self.initialState = initialState
        return self
    }
    
    func build() -> UIViewController {
        let presenter = RegistrationPresenter()
        let interactor = RegistrationInteractor(presenter: presenter)
        let controller = RegistrationViewController(interactor: interactor)
        
        presenter.viewController = controller
        return controller
    }
}
