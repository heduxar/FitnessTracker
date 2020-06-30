//
//  RegistrationInteractor.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import CryptoKit
import RealmSwift

protocol RegistrationBusinessLogic {
    func checkUser(request: Registration.CheckUserName.Request)
    func registerUser(request: Registration.RegistrationUser.Request)
}

final class RegistrationInteractor: RegistrationBusinessLogic {
    
    // MARK: - Private Properties
    private let presenter: RegistrationPresentationLogic
    
    // MARK: - Object Lifecycle
    init(presenter: RegistrationPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Logic
    func checkUser(request: Registration.CheckUserName.Request) {
        let response: Registration.CheckUserName.Response
        if ((try? RealmProvider.get(RealmUserModel.self)
            .filter("login == %@", request.login).first) != nil) {
            response = Registration.CheckUserName.Response(userExists: true)
        } else {
            response = Registration.CheckUserName.Response(userExists: false)
        }
        presenter.presentUserExists(response: response)
    }
    
    func registerUser(request: Registration.RegistrationUser.Request) {
        guard let passHash = SHA256.hash(data: Data(request.password.utf8))
            .compactMap { String(format: "%02x", $0) }.first else { return }
        let user = RealmUserModel()
        user.login = request.login
        user.password = passHash
        let response: Registration.RegistrationUser.Response
        do {
            try RealmProvider.save(items: [user])
            response = Registration.RegistrationUser.Response(isRegister: true)
        } catch {
            response = Registration.RegistrationUser.Response(isRegister: false)
        }
        presenter.presentUserRegistration(response: response)
    }
}
