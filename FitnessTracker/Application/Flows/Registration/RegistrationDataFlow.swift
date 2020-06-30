//
//  RegistrationDataFlow.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

enum Registration {
    // MARK: - Use cases
    enum CheckUserName {
        struct Request {
            let login: String
        }
        
        struct Response {
            let userExists: Bool
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum RegistrationUser {
        struct Request {
            let login: String
            let password: String
        }
        
        struct Response {
            let isRegister: Bool
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case initial
        case success
        case registration
        case failure(error: RegistrationError)
    }
    
    enum RegistrationError: Error {
        case userExists, somethingGoneWrong
    }
}
