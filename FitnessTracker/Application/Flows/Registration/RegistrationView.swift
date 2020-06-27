//
//  RegistrationView.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol RegistrationViewDelegate: class {
  
}

extension RegistrationView {
  struct ViewMetrics {
    
  }
}

final class RegistrationView: UIView {
  
  // MARK: - Private Properties
  private let viewMetrics = ViewMetrics()
  
  // MARK: - Public Properties
  weak var delegate: RegistrationViewDelegate?
  
  // MARK: - View Properties
  fileprivate(set) lazy var customView: UIView = {
    let view = UIView()
    return view
  }()
  
  // MARK: - Object Lifecycle
  override init(frame: CGRect = CGRect.zero) {
    super.init(frame: frame)
    addSubviews()
    makeConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Methods
  private func setupView() {
    
  }
  
  private func addSubviews() {
    addSubview(customView)
  }
  
  private func makeConstraints() {
    
  }
}
