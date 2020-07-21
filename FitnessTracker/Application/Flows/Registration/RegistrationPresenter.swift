//
//  RegistrationPresenter.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationPresentationLogic {
    func presentUserExists(response: Registration.CheckUserName.Response)
    func presentUserRegistration(response: Registration.RegistrationUser.Response)
}

final class RegistrationPresenter: RegistrationPresentationLogic {
    weak var viewController: RegistrationDisplayLogic?
    
    // MARK: - Presenting methods
    func presentUserExists(response: Registration.CheckUserName.Response) {
        var viewModel: Registration.CheckUserName.ViewModel
        if response.userExists {
            viewModel = Registration.CheckUserName.ViewModel(state: .failure(error: .userExists))
        } else {
            viewModel = Registration.CheckUserName.ViewModel(state: .registration)
        }
        viewController?.displayCheckUserName(viewModel: viewModel)
    }
    
    func presentUserRegistration(response: Registration.RegistrationUser.Response) {
        var viewModel:Registration.RegistrationUser.ViewModel
        if response.isRegister {
            viewModel = Registration.RegistrationUser.ViewModel(state: .success(userID: response.userID!))
        } else {
            viewModel = Registration.RegistrationUser.ViewModel(state: .failure(error: .somethingGoneWrong))
        }
        viewController?.displayRegisterUser(viewModel: viewModel)
    }
}
