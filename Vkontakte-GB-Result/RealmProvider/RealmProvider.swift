//
//  RealmProvider.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 25.05.2019Saturday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmProvider {
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
    @discardableResult
    static func saveToRealm<T: Object> (items: [T]) -> Realm {
        let realm = try! Realm(configuration: RealmProvider.configuration)
        
        do {
            try realm.write {
                let oldNews = realm.objects(T.self)
                realm.delete(oldNews)
                realm.add(items, update: .modified)
//                print(realm.configuration.fileURL!)
            }
        } catch  {
            print(error.localizedDescription)
        }
        return realm
    }
    
    static func get<T: Object> (_ type: T.Type, in realm: Realm? = try? Realm(configuration: RealmProvider.configuration)) -> Results<T>? {
//        print(realm!.configuration.fileURL)
        return realm?.objects(type)
    }
}
