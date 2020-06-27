//
//  MainInteractor.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol MainBusinessLogic {
  func doSomething(request: Main.Something.Request)
}

final class MainInteractor: MainBusinessLogic {
  
  // MARK: - Private Properties
  private let presenter: MainPresentationLogic
  
  // MARK: - Object Lifecycle
  init(presenter: MainPresentationLogic) {
    self.presenter = presenter
  }
  
  // MARK: - Do something
  func doSomething(request: Main.Something.Request) {
    
  }
}
