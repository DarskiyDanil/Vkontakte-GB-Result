//
//  AddGroupRealm.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 25.05.2019Saturday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import RealmSwift

class AddGroupRealm: Object {
    @objc dynamic var groupAdd = ""
    @objc dynamic var id = 0
    
    convenience init(groupAdd: String, groupId: Int) {
        self.init()
        self.groupAdd = groupAdd
        self.id = groupId
    }
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
}
extension AddGroupRealm {
    public func delete() {
        do {
            let realm = try Realm(configuration: RealmProvider.configuration)
            
            try realm.write {
                realm.delete(self)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
//MARK: CRUD metods
extension AddGroupRealm {
    
    // метод запроса всех результатов из базы данных
    static func getAddGroupsRealm() throws -> Results<AddGroupRealm> {
        let realm = try Realm()
        return realm.objects(AddGroupRealm.self)
    }
    
    //    сохранение массива данных
    static func saveAddGroupsRealm(_ AddGroupsRealm: [AddGroupRealm]) {
        //  обработка исключений
        do {
//            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            // получаем доступ к хранилищу
            let realm = try Realm(/*configuration: config*/)
            //            print(realm.configuration.fileURL!)
            let oldAddGroups = realm.objects(AddGroupRealm.self)
            // начало работы с базой данных
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(oldAddGroups)
            // сохраняем
            realm.add(AddGroupsRealm)
            //  завершаем сохранение
            try realm.commitWrite()
        } catch {
            // иначе выводим ошибку
            print(error.localizedDescription)
        }
    }
}

