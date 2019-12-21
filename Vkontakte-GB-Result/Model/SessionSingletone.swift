//
//  AccountInitialization.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 02.05.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
//
class SessionSingletone {
    
    static let shared = SessionSingletone()
    private init(){}
    
    // token  каждый раз разный и привязан к этой сессии и устройству для безопасности
    var token = ""
    var IdUser = Int()
    var idFRIEND = ""
    let apiVersion = "5.95"
    let userId = "6646537"
    let baseUrl = "https://api.vk.com"
}
