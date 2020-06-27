//
//  RegistrationViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationDisplayLogic: class {
  func displaySomething(viewModel: Registration.Something.ViewModel)
}

final class RegistrationViewController: UIViewController {
  
  // MARK: - Private Properties
  private let interactor: RegistrationBusinessLogic
  private var state: Registration.ViewControllerState
  
  // MARK: - Object Lifecycle
  init(interactor: RegistrationBusinessLogic, initialState: Registration.ViewControllerState = .initial) {
    self.interactor = interactor
    self.state = initialState
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  override func loadView() {
    let view = RegistrationView(frame: UIScreen.main.bounds)
    view.delegate = self
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doSomething()
  }
  
  // MARK: - Private Methods
  private func doSomething() {
    let request = Registration.Something.Request()
    interactor.doSomething(request: request)
  }
}

// MARK: - Display Logic
extension RegistrationViewController: RegistrationDisplayLogic {
  func displaySomething(viewModel: Registration.Something.ViewModel) {
    display(newState: viewModel.state)
  }
  
  func display(newState: Registration.ViewControllerState) {
    state = newState
    switch state {
    case .initial:
      print("initial state")
    case let .failure(error):
      print("error \(error)")
    case let .result(items):
      print("result: \(items)")
    case .emptyResult:
      print("empty result")
    }
  }
}

// MARK: - View Delegate
extension RegistrationViewController: RegistrationViewDelegate {
  
}
