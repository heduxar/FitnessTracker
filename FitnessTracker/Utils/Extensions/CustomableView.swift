//
//  CustomableView.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 15.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit

protocol CustomableView {
  associatedtype RootView: UIView
}

extension CustomableView where Self: UIViewController {
  func view() -> RootView {
    return self.view as! RootView
  }
  
  func optionalView() -> RootView? {
    return self.view as? RootView
  }
}
