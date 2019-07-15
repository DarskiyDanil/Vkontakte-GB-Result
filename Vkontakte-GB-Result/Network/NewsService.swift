//
//  NewsService.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 26.06.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsService {
    
    static let newsService = NewsService()
    private var news = [NewsRealmSwiftyJsone]()
    private var users = [FriendsRealmSwiftyJSON]()
    private var groups = [GroupsRealmSwiftyJSON]()
    
    //    private var news = [NewsRealmSwiftyJsone]()
    var user_id = String(SessionSingletone.shared.userId)
    var token = SessionSingletone.shared.token
    
    //    фотографии друзей
    func requestNewsAlamofire(completion: (([NewsRealmSwiftyJsone]?, Error?) -> Void)? = nil ) {
        let baseUrl = SessionSingletone.shared.baseUrl
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            //            "owner_id": ownerId,
            "access_token": SessionSingletone.shared.token,
            "filters": "post,photo",
            "max_photos": "1",
            "count": "50",
            "v": "5.92"/*SessionSingletone.shared.apiVersion*/
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseJSON { [weak self] (response) in
            // здесь будет парсинг
            //  result  результат (успех или провал)
            switch response.result {
            case .success(let value):

//                guard let strongSelf = self else {
//                    return
//                }
                
                let json = JSON(value)
                self?.news = json["response"]["items"].arrayValue.map { NewsRealmSwiftyJsone(json: $0)}
                self?.users = json["response"]["profiles"].arrayValue.map { FriendsRealmSwiftyJSON(json: $0)}
                self?.groups = json["response"]["groups"].arrayValue.map { GroupsRealmSwiftyJSON(json: $0)}
                self?.news = (self?.news.filter { $0.textNews != "" || $0.imageURL != "" })!
                self?.identifyNewsSource()

//                self?.saveUsersNewsList(strongSelf.news)
                
                print(json)
                //  при успешности волучам массив друзей и вместо ошибки nil
                completion?(self?.news, nil)
            case .failure(let error):
                // иначе получаем ошибку
                completion?(nil, error)
            }
        }
    }
    
    func identifyNewsSource() {
        for post in self.news {
            if post.sourceId > 0 {
                let index = users.firstIndex(where: { (item) -> Bool in
                    item.id == post.sourceId
                })
                post.newsName = "\(users[index!].firstName) \(users[index!].lastName)"
                post.newsPhoto = users[index!].imageUrl
            } else {
                let index = groups.firstIndex(where: { (item) -> Bool in
                    item.id == post.sourceId * -1
                })
                post.newsName = groups[index!].name
                post.newsPhoto = groups[index!].imageUrl
            }
        }
    }
//    ----------------------
//    func saveUsersNewsList(_ news: [NewsRealmSwiftyJsone]) {
//        do {
//            let realm = try Realm()
//            let oldUsersNewsList = realm.objects(NewsRealmSwiftyJsone.self)
//            try realm.write {
//                realm.delete(oldUsersNewsList)
//                realm.add(news)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    
    
}
