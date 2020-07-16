//
//  LoginPresenter.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import CryptoKit

protocol LoginPresentationLogic {
    func presentLogin(response: Login.Login.Response)
}

final class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?
    
    // MARK: - Presenter methods
    func presentLogin(response: Login.Login.Response) {
        var viewModel: Login.Login.ViewModel
        guard let user = response.user
            else {
                    viewModel = Login.Login.ViewModel(state: .failure(error: .loginError))
                    viewController?.displayLogin(viewModel: viewModel)
                    return
        }
        let passwordHash = SHA256.hash(data: Data(response.password.utf8))
            .compactMap({ String(format: "%02x", $0)}).joined()
        
        switch passwordHash {
        case user.password:
            viewModel = Login.Login.ViewModel(state: .success(userID: user.id))
        default:
            viewModel = Login.Login.ViewModel(state: .failure(error: .passwordError))
        }
        
        viewController?.displayLogin(viewModel: viewModel)
    }
}
