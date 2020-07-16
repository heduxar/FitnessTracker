//
//  RealmTrackModel.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 24.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import RealmSwift

final class RealmTrackModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var userID: Int = 0
    @objc dynamic var startTime: Date = Date()
    @objc dynamic var endTime: Date = Date()
    let locationPoints = List<RealmCoordinatesModel>()
    
    override static func primaryKey() -> String? {
        "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmTrackModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
