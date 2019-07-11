//
//  VkoLoginWebViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 09.05.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.

import UIKit
import WebKit

import Alamofire
import Firebase
import FirebaseFirestore
import FirebaseAuth

class VkoLoginWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
//private let ref = Database.database().reference(withPath: "User")
    
    var userInfo = [String].self
    //  запрос инициализации
    private func requestLogin() {
        // Создайте URL входа со всеми необходимыми параметрами
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: SessionSingletone.shared.userId),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "270342"), /*262150 права доступа*/ 
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: SessionSingletone.shared.apiVersion)
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  авторизация
        requestLogin()
       

        

    }
}

extension VkoLoginWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, parameters in
                var dictionary = result
                let key = parameters[0]
                let value = parameters[1]
                dictionary[key] = value
                return dictionary
        }
        
        guard let tokenAccess = parameters["access_token"], let userID = Int(parameters["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil { print(error!.localizedDescription) }
            let user = authResult!.user
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            
            
//            let groupRef = self.ref.child(String(uid).lowercased())
//            groupRef.setValue(user)

            
            self.performSegue(withIdentifier: "VkoLoginSegue", sender: nil)
            }
        


//        let userID = Auth.auth().currentUser?.uid

        
        //   сохранение токена
        SessionSingletone.shared.token = tokenAccess
        SessionSingletone.shared.IdUser = userID
        
        

 
                //  объединённый сетевой запрос
                //    connectUserData()
                
        decisionHandler(.cancel)
                //  переход по сеге
        
    }
    
    
    
    
    // объединённые запросы
    private func connectUserData() {
        //      VkoService.vkoService.requestUsersGroupsAlamofire()
        //      VkoService.vkoService.requestUsersFriendsAlamofire()
        //        VkoService.vkoService.requestUsersPhotosAlamofire(ownerId: "")
    }
    
    
}
