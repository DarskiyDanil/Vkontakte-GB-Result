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

class NewsService {
    
    static let newsService = NewsService()
    
    
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
            "filters": "post, photo",
            "max_photos": "1",
            "count": "10",
            "v": "5.92"/*SessionSingletone.shared.apiVersion*/
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseJSON { (response) in
            // здесь будет парсинг
            //  result  результат (успех или провал)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let news = json["response"]["items"].arrayValue.map { NewsRealmSwiftyJsone(json: $0)}
                print(json)
                //  при успешности волучам массив друзей и вместо ошибки nil
                completion?(news, nil)
            case .failure(let error):
                // иначе получаем ошибку
                completion?(nil, error)
            }
        }
    }
    
    
    
    
    
    
    
}
