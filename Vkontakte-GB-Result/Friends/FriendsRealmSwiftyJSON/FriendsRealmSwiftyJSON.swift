//
//  User.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 12.05.2019Sunday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//
import UIKit
import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers class FriendsRealmSwiftyJSON: Object {
// переменные которые будут хранить данные из JSON
    dynamic var id = 0
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var imageUrl = ""


//    let photos2 = List<PhotoRealmSwiftyJSON>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
// присваиваю переменным инициализаторы
// если глюканёт то снести , photos: [PhotoRealmSwiftyJSON] = []
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.imageUrl = json["photo_50"].stringValue
        
        
    }
//    let photos = LinkingObjects(fromType: PhotoRealmSwiftyJSON.self, property: "friends1")
}

//MARK: CRUD metods
extension FriendsRealmSwiftyJSON {
    
// метод запроса всех результатов из базы данных
    static func getFriendsRealm() throws -> Results<FriendsRealmSwiftyJSON> {
        let realm = try Realm()
        return realm.objects(FriendsRealmSwiftyJSON.self)
    }
    
//    сохранение массива данных
    static func saveFriendsRealm(_ friendsRealm: [FriendsRealmSwiftyJSON]) {
//  обработка исключений
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
// получаем доступ к хранилищу
            let realm = try Realm(configuration: config)
            
            print(realm.configuration.fileURL!)
            
            let oldFriends = realm.objects(FriendsRealmSwiftyJSON.self)
            
// начало работы с базой данных
            realm.beginWrite()
            
            // удаляем старые данные
            realm.delete(oldFriends)
            
// сохраняем или update: .all
            realm.add(friendsRealm, update: .modified)
            
//  завершаем сохранение
            try realm.commitWrite()
            
        } catch {
// иначе выводим ошибку
            print(error.localizedDescription)
        }
    }
}



//extension FriendsSwiftyJSON: CustomStringConvertible {
//    var description: String {
//        return "\(firstName) \(lastName)"
//    }
//}
//{
//    response =     {
//        count = 20;
//        items =         (
//            {
//                "can_access_closed" = 1;
//                "first_name" = Alena;
//                id = 224629563;
//                "is_closed" = 0;
//                "last_name" = Starostenko;
//                nickname = "";
//                online = 0;
//                "photo_50" = "https://pp.wVEg/_hd";
//        },
//}
