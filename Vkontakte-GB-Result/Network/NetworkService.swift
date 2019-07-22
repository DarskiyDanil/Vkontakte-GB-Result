//
//  NetworkService.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 05.05.2019Sunday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    //    для запросов
    func sendRequest() {
        // создаём URL
        //        let url = URL(string: "https://api.vk.com")
        //        разбиваем код на составляющие для избегания ошибок
        var urlConstuctor = URLComponents()
        urlConstuctor.scheme = "https"
        urlConstuctor.host = "api.vk.com"
        //        путь к желаемому результату
        urlConstuctor.path = "/authorize"
        //        параметры
        urlConstuctor.queryItems = [
            URLQueryItem(name: "client_id", value: "6646537"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        //        создём и конфигурируем свою сессию
        let configuration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: configuration)
        
        //        создаём реквест на базе urlConstuctor
        let request = URLRequest(url: urlConstuctor.url!)
        
        //        создаём задачу для сервера и варианты ответа сервера
        let task = session.dataTask(with: request) { (data, response, error) in
            //  варианты действий
            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) {
                
                print(json)
            }
        }
        task.resume()
    }
    
    //   sendRequest на базе Alamofire
    func sendAlamofireRequest() {
        
        AlamofireSession.sharedManager.request("http://samples.openweathermap.org/data/2.5/forecast?q=Moscow,DE&appid=b1b15e88fa797225412429c1c50c122a1").responseJSON { (response) in
            // получаем value
            //            если ответ не получен, возвращаем
            guard let value = response.value else { return }
            //если ответ есть
            print(value)
        }   
    }
    
    //   post запрос на базе Alamofire
    func sendAlamofireRequestPost() {
        let urlString = "https://httpbin.org/post"
        AlamofireSession.sharedManager.request(urlString, method: .post, parameters: ["foo": "bar"]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}


