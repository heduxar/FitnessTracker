//
//  RegistrationInteractor.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationBusinessLogic {
  func doSomething(request: Registration.Something.Request)
}

final class RegistrationInteractor: RegistrationBusinessLogic {
  
  // MARK: - Private Properties
  private let presenter: RegistrationPresentationLogic
  
  // MARK: - Object Lifecycle
  init(presenter: RegistrationPresentationLogic) {
    self.presenter = presenter
  }
  
  // MARK: - Do something
  func doSomething(request: Registration.Something.Request) {
    
  }
}
