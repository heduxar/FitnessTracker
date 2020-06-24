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
    let locationPoints = List<RealmCoordinatesModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
