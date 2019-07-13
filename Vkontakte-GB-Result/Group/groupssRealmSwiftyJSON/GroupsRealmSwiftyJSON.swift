//
//  GroupsSwiftyJSON.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 15.05.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

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
    
    // присваиваю переменным инициализаторы
    convenience init(json: JSON) {
        self.init()
    DispatchQueue.global().async {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.imageUrl = json["photo_50"].stringValue
        self.membersCount = json["members_count"].intValue
        self.isClosed = json["is_closed"].boolValue
        self.isMember = json["is_member"].boolValue
        }
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
//            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
 // получаем доступ к хранилищу
            let realm = try Realm(/*configuration: config*/)
            
      let oldGroups = realm.objects(GroupsRealmSwiftyJSON.self)
            
            // начало работы с базой данных
            realm.beginWrite()
           
            // удаляем старые данные
            realm.delete(oldGroups)
            
            // сохраняем
             realm.add(groupsRealm)
                
            
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
//{
//    response =     {
//        count = 18;
//        items =         (
//            {
//                id = 58269125;
//                "is_admin" = 0;
//                "is_advertiser" = 0;
//                "is_closed" = 0;
//                "is_member" = 0;
//                name = "\U041e\U0442\U0442\U0440\U0430\U0445\U0430\U043d\U044b\U0435 \U0448\U043b\U044e\U0445\U0438";
//                "photo_100" = "https://EYZYeY.jpg?ava=1";
//                "photo_200" = "https://sunU.jpg?ava=1";
//                "photo_50" = "https://sun1-84.useva=1";
//                "screen_name" = iporns;
//                type = page;
//        },

//        );
//    };
//}
