//
//  MainBuilder.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

final class MainBuilder {
  
  // MARK: - Private Properties
  private var initialState: Main.ViewControllerState?
  
  // MARK: - Public Methods
  func set(initialState: Main.ViewControllerState) -> MainBuilder {
    self.initialState = initialState
    return self
  }
  
  func build() -> UIViewController {
    let presenter = MainPresenter()
    let interactor = MainInteractor(presenter: presenter)
    let controller = MainViewController(interactor: interactor)
    
    presenter.viewController = controller
    return controller
  }
}
