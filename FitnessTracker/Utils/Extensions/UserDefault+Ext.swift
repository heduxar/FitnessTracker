//
//  UserDefault+Ext.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit

extension UserDefaults {
    var isLogined: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var isSecuredScreen: Bool {
        get {
            register(defaults: [#function : false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
