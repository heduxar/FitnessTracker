//
//  LoginPresenter.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol LoginPresentationLogic {
    func presentSomething(response: Login.Something.Response)
}

final class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?
    
    // MARK: - Present something
    func presentSomething(response: Login.Something.Response) {
        
    }
}
