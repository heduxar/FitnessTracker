//
//  LoginInteractor.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import RealmSwift

protocol LoginBusinessLogic {
    func requestLogin(request: Login.Login.Request)
}

final class LoginInteractor: LoginBusinessLogic {
    
    // MARK: - Private Properties
    private let presenter: LoginPresentationLogic
    
    // MARK: - Object Lifecycle
    init(presenter: LoginPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Interactor methods
    func requestLogin(request: Login.Login.Request) {
        var response: Login.Login.Response
        if let user = try? RealmProvider.get(RealmUserModel.self)
            .first (where: { $0.login == request.login }) {
            response = Login.Login.Response(user: user,
                                            password: request.password)
        } else {
            response = Login.Login.Response(user: nil,
                                            password: request.password)
        }
        presenter.presentLogin(response: response)
    }
}
