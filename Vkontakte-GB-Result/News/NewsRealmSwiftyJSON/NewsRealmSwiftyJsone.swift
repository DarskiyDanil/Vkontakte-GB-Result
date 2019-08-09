//
//  NewsRealmSwiftyJsone.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 26.06.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import RealmSwift

@objcMembers class NewsRealmSwiftyJsone: Object {
    // переменные которые будут хранить данные из JSON
    dynamic var sourceId = 0
    dynamic var postId = 0
    dynamic var newsName = ""
    dynamic var newsPhoto = ""
    dynamic var textNews = ""
    dynamic var imageURL = ""
    dynamic var imageWidth = 0
    dynamic var imageHeight = 0
    dynamic var likesCount = 0
    dynamic var userLikes = 0
    dynamic var commentsCount = 0
    dynamic var repostsCount = 0
    dynamic var userReposted = 0
    dynamic var views = 0
    
    override class func primaryKey() -> String? {
        return "postId"
    }
    
    // присваиваю переменным инициализаторы
    convenience init(json: JSON) {
        self.init()
        
        DispatchQueue.global().async {
            self.sourceId = json["source_id"].intValue
            self.postId = json["post_id"].intValue
            self.newsName = json["name"].stringValue
            self.newsPhoto = json["photo_100"].stringValue
            self.textNews = json["text"].stringValue
            
            if json["type"] == "post" {
                for size in json["attachments"][0]["photo"]["sizes"].arrayValue {
                    if size["type"].stringValue == "x" {
                        self.imageURL = size["url"].stringValue
                        self.imageWidth = size["width"].intValue
                        self.imageHeight = size["height"].intValue
                    }
                }
            } else {
                for size in json/*["attachments"][0]*/["photos"]["items"][0]["sizes"].arrayValue {
                    if size["type"].stringValue == "x" {
                        self.imageURL = size["url"].stringValue
                        self.imageWidth = size["width"].intValue
                        self.imageHeight = size["height"].intValue
                    }
                }
            }
            
            self.likesCount = json["likes"]["count"].intValue
            self.userLikes = json["likes"]["user_likes"].intValue
            self.commentsCount = json["comments"]["count"].intValue
            self.repostsCount = json["reposts"]["count"].intValue
            self.userReposted = json["reposts"]["user_reposted"].intValue
            self.views = json["views"]["count"].intValue
            
        }
    }
}

//MARK: CRUD metods
extension NewsRealmSwiftyJsone {
    
    // метод запроса всех результатов из базы данных
    static func getNewsRealm() throws -> Results<NewsRealmSwiftyJsone> {
        let realm = try Realm()
        return realm.objects(NewsRealmSwiftyJsone.self)
    }
    
    //    сохранение массива данных
    static func saveNewsRealm(_ newsRealm: [NewsRealmSwiftyJsone]) {
        //  обработка исключений
        do {
            // получаем доступ к хранилищу
            let realm = try Realm(/*configuration: config*/)
            
                        print(realm.configuration.fileURL!)
            
            let oldNews = realm.objects(NewsRealmSwiftyJsone.self)
            
            // начало работы с базой данных
            realm.beginWrite()
            
            // удаляем старые данные
            realm.delete(oldNews)
            
            // сохраняем
            realm.add(newsRealm, update: .modified)
            
            //  завершаем сохранение
            try realm.commitWrite()
            
        } catch {
            // иначе выводим ошибку
            print(error.localizedDescription)
        }
    }
    
    
    
}
