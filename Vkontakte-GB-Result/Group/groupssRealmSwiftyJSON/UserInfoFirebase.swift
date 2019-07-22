//
//  UserInfi.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 09.06.2019Sunday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import RealmSwift
import Firebase

class UserInfoFirebase {
    //     сущьность
    var id: Int
    var addGroups: String
    let ref: DatabaseReference?
    
    //    инициализация
    
    init(id: Int, addGroups: String) {
        self.id = id
        self.addGroups = addGroups
        self.ref = nil
    }
    
    // инициализация данных от Firebase
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let addGroups = value["addGroups"] as? String

            else { return nil }
        self.ref = snapshot.ref
        self.id = id
        self.addGroups = addGroups
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "addGroups": addGroups,
            "id": id]
        
        
    }
    
}
