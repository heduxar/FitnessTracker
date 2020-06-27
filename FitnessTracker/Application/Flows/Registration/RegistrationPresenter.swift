//
//  RegistrationPresenter.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationPresentationLogic {
  func presentSomething(response: Registration.Something.Response)
}

final class RegistrationPresenter: RegistrationPresentationLogic {
  weak var viewController: RegistrationDisplayLogic?
  
  // MARK: - Present something
  func presentSomething(response: Registration.Something.Response) {
    
  }
}
