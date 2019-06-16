//
//  AlamofireSession.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 08.05.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireSession {
    public static let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
}
