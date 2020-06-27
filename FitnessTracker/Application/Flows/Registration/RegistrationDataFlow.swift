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
  enum Something {
    struct Request {
    }
    
    struct Response {
//      var result: AFResult<>
    }
    
    struct ViewModel {
      var state: ViewControllerState
    }
  }
  
  enum ViewControllerState {
    case initial
    case result([Any/*viewModel*/])
    case emptyResult
    case failure(error: RegistrationError)
  }
  
  enum RegistrationError: Error {
    case someError(message: String)
  }
}
