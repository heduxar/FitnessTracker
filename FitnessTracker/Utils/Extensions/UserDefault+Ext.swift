//
//  UserDefault+Ext.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit

extension UserDefaults {
    var isLoginedUserID: Int {
        get {
            register(defaults: [#function: 0])
            return integer(forKey: #function)
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
    
    var isTrackRoute: Bool {
        get {
            register(defaults: [#function : false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
