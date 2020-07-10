//
//  LoginDataFlow.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

enum Login {
    // MARK: - Use cases
    enum Login {
        struct Request {
            let login: String
            let password: String
        }
        
        struct Response {
            let user: RealmUserModel?
            let password: String
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case initial
        case success
        case failure(error: LoginError)
    }
    
    enum LoginError: Error {
        case loginError, passwordError
    }
}
