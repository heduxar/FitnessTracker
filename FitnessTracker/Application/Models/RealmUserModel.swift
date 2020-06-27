//
//  RealmUserModel.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import RealmSwift
import CryptoKit

final class RealmUserModel: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}
