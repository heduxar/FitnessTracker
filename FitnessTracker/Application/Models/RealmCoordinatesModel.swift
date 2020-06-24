//
//  RealmCoordinatesModel.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 24.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import RealmSwift
import CoreLocation

final class RealmCoordinatesModel: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}
