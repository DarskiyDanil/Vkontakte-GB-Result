//
//  PhotoSwiftyJSON.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 16.05.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers class PhotoRealmSwiftyJSON: Object {
    // переменные которые будут хранить данные из JSON
    dynamic var ownerId = 0
    dynamic var id = 0
    dynamic var imageUrl = ""
    
    // присваиваю переменным инициализаторы
    convenience init(json: JSON, ownerId: String) {
        self.init()
        DispatchQueue.global().async {
            self.ownerId = json["owner_id"].intValue
            self.id = json["id"].intValue
            self.imageUrl = json["sizes"][2]["url"].stringValue
        }
    }
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}

//MARK: CRUD metods
extension PhotoRealmSwiftyJSON {
    // метод запроса всех результатов из базы данных
    static func gettPhotoFriendRealm(in ownerId: String) throws -> Results<PhotoRealmSwiftyJSON> {
        let realm = try Realm()
        return realm.objects(PhotoRealmSwiftyJSON.self)/*.filter("ownerId == %@", ownerId)*/
    }
    //    сохранение массива данных
    static func savePhotoRealm(_ photoRealm: [PhotoRealmSwiftyJSON], ownerId: String) {
        do {
            //            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            
            let realm = try Realm(/*configuration: config*/)
            
            let oldPhotos = realm.objects( PhotoRealmSwiftyJSON.self)
            //            guard let oldPhotos = realm.object(ofType: PhotoRealmSwiftyJSON.self, forPrimaryKey: Int(ownerId)) else {
            //                return
            //            }
            
            // начало изменения хранилища
            realm.beginWrite()
            
            // удаляем старые данные
            realm.delete(oldPhotos)
            
            // сохраняем
            realm.add(photoRealm/*, update: .all*/)
            //            завершение записи в хранилище
            try realm.commitWrite()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}


//{
//    response =     {
//        count = 3;
//        items =         (
//            {
//                "album_id" = "-6";
//                date = 1379699183;
//                id = 311209797;
//                lat = "51.672981";
//                long = "-116.449517";
//                "owner_id" = 224629563;
//                "post_id" = 2;
//                sizes =                 (
//                    {
//                        height = 75;
//                        type = s;
//                        url = "https://pp.userapi.com/kAfsIsAVt78.g";
//                        width = 75;
//                },
