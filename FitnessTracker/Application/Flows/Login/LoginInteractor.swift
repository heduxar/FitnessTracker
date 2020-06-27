//
//  LoginInteractor.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol LoginBusinessLogic {
    func doSomething(request: Login.Something.Request)
}

final class LoginInteractor: LoginBusinessLogic {
    
    // MARK: - Private Properties
    private let presenter: LoginPresentationLogic
    
    // MARK: - Object Lifecycle
    init(presenter: LoginPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Do something
    func doSomething(request: Login.Something.Request) {
        
    }
}
