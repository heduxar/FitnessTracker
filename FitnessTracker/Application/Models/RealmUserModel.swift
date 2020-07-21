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
    @objc dynamic var id: Int = 0
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var userAvatar: Data = Data()
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmUserModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
