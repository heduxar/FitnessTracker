//
//  RealmProvider.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 24.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import RealmSwift

final class RealmProvider {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save <T: Object>(items: [T],
                                 configuration: Realm.Configuration = deleteIfMigration,
                                 update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }
    
    static func get<T: Object>(_ type: T.Type,
                               configuration: Realm.Configuration = deleteIfMigration) throws -> Results<T> {
        print(configuration.fileURL ?? "")
        let realm = try Realm(configuration: configuration)
        return realm.objects(type)
    }
    
    static func delete<T:Object>(item: T,
                                 configuration: Realm.Configuration = deleteIfMigration,
                                 update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        try realm.write {
            realm.delete(item)
        }
    }
    
    static func clearDB(configuration: Realm.Configuration = deleteIfMigration) throws {
        let realm = try Realm(configuration: configuration)
        try realm.write {
            realm.deleteAll()
        }
    }
}
