//
//  RealmChanges.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 06.06.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        beginUpdates()
        deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
        insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
        reloadRows(at: updates.map({IndexPath(row: $0, section: 0)}), with: .automatic)
        endUpdates()
    }
}


