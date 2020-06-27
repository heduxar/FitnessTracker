//
//  MainPresenter.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
  func presentSomething(response: Main.Something.Response)
}

final class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  // MARK: - Present something
  func presentSomething(response: Main.Something.Response) {
    
  }
}
