//
//  GroupsSwiftyJSON.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 15.05.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers class GroupsRealmSwiftyJSON: Object {
    // переменные которые будут хранить данные из JSON
    dynamic var id = 0
    dynamic var name = ""
    dynamic var imageUrl = ""
    dynamic var membersCount = 0
    dynamic var isClosed = false
    dynamic var isMember = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // присваиваю переменным инициализаторы
    convenience init(json: JSON) {
        self.init()
        //    DispatchQueue.global().async {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.imageUrl = json["photo_50"].stringValue
        self.membersCount = json["members_count"].intValue
        self.isClosed = json["is_closed"].boolValue
        self.isMember = json["is_member"].boolValue
        //        }
    }
    
}

//extension GroupsRealmSwiftyJSON {
//   var descript: String {
//        return "\(id) \(name)"
//    }
//}

//MARK: CRUD metods
extension GroupsRealmSwiftyJSON {
    // метод запроса всех результатов из базы данных
    static func getGroupsRealm() throws -> Results<GroupsRealmSwiftyJSON> {
        let realm = try Realm()
        return realm.objects(GroupsRealmSwiftyJSON.self)
    }
    //    сохранение массива данных
    static func saveGroupsRealm(_ groupsRealm: [GroupsRealmSwiftyJSON]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            // получаем доступ к хранилищу
            let realm = try Realm(configuration: config)
            
            let oldGroups = realm.objects(GroupsRealmSwiftyJSON.self)
            
            // начало работы с базой данных
            realm.beginWrite()
            
            // удаляем старые данные
            realm.delete(oldGroups)
            
            // сохраняем
            realm.add(groupsRealm, update: .modified)
            
            //  завершаем сохранение
            try realm.commitWrite()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

//extension GroupsSwiftyJSON: CustomStringConvertible {
//    var description: String {
//        return "\(name) \(membersCount)"
//    }
//}

