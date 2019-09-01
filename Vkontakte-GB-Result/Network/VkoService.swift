//
//  VkoService.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 09.05.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VkoService {
    
    static let vkoService = VkoService()
    //    private init() {}
    var user_id = String(SessionSingletone.shared.userId)
    var token = SessionSingletone.shared.token
    
    // группы пользователя
    func requestUsersGroupsAlamofire(completion: (([GroupsRealmSwiftyJSON]?, Error?) -> Void)? = nil ) {
        DispatchQueue.global(qos: .utility).async {
            let baseUrl = SessionSingletone.shared.baseUrl
            let path = "/method/groups.get"
            let parameters: Parameters = [
                "user_id": SessionSingletone.shared.IdUser,
                "access_token": SessionSingletone.shared.token,
                "extended": "1",
                "v": SessionSingletone.shared.apiVersion
            ]
            
            Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let groups = json["response"]["items"].arrayValue.map { GroupsRealmSwiftyJSON(json: $0)}
                    //  при успешности волучам массив друзей и вместо ошибки nil
                    completion?(groups, nil)
                case .failure(let error):
                    //                print(error.localizedDescription)
                    // иначе получаем ошибку
                    completion?(nil, error)
                }
            }
        }
    }
    //  друзья
    func requestUsersFriendsAlamofire(completion: (([FriendsRealmSwiftyJSON]?, Error?) -> Void)? = nil ) {
        DispatchQueue.global(qos: .utility).async {
            let baseUrl = SessionSingletone.shared.baseUrl
            let path = "/method/friends.get"
            let parameters: Parameters = [
                "user_id": SessionSingletone.shared.IdUser,
                "access_token": SessionSingletone.shared.token,
                "count": "50",
                "order": "hints",
                "fields": "nickname, photo_50",
                "v": SessionSingletone.shared.apiVersion
            ]
            //            преобразуем полученные данные в JSON
            Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let friends = json["response"]["items"].arrayValue.map { FriendsRealmSwiftyJSON(json: $0)}
                    //  при успешности волучам массив друзей и вместо ошибки nil
                    completion?(friends, nil)
                case .failure(let error):
                    // иначе получаем ошибку
                    completion?(nil, error)
                }
            }
        }
    }
    //    фотографии друзей
    func requestUsersPhotosAlamofire(ownerId: String, completion: (([PhotoRealmSwiftyJSON]?, Error?) -> Void)? = nil ) {
        DispatchQueue.global(qos: .utility).async {
            let baseUrl = SessionSingletone.shared.baseUrl
            let path = "/method/photos.get"
            let parameters: Parameters = [
                "owner_id": ownerId,
                "access_token": SessionSingletone.shared.token,
                "album_id": "profile",
                "rev": "0",
                "count": "50",
                "v": SessionSingletone.shared.apiVersion
            ]
            
            Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let photos = json["response"]["items"].arrayValue.map { PhotoRealmSwiftyJSON(json: $0, ownerId: ownerId)}
                    //  при успешности волучам массив друзей и вместо ошибки nil
                    completion?(photos, nil)
                case .failure(let error):
                    // иначе получаем ошибку
                    completion?(nil, error)
                }
            }
        }
    }
    
    // поиск по гуппам
    func searchGroupsNameAlamofire(searchName: String, completion: (([ GroupsRealmSwiftyJSON]?, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .utility).async {
            let baseUrl = SessionSingletone.shared.baseUrl
            let path = "/method/groups.search"
            let parameters: Parameters = [
                "user_id": SessionSingletone.shared.userId,
                "access_token": SessionSingletone.shared.token,
                "q": searchName,
                "count": "50",
                "v": SessionSingletone.shared.apiVersion
            ]
            
            Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let search = json["response"]["items"].arrayValue.map { GroupsRealmSwiftyJSON(json: $0)}
                    //  при успешности волучам массив друзей и вместо ошибки nil
                    completion?(search, nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
