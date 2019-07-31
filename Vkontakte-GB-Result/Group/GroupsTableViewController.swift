//
//  GroupsTableViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 08.04.2019Monday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseAuth

class GroupsTableViewController: UITableViewController {
//     ссылка на корневую ветку в Firebase
//    var ref: DatabaseReference!
    var userIdentification = String(SessionSingletone.shared.IdUser)
    private var groups = [UserInfoFirebase]()
    private let ref = Database.database().reference(withPath: "userAddGroup")
//    var groups = [String]()
    let userID = Auth.auth().currentUser?.uid
//    private var groups: Results<AddGroupRealm>?
//    private var notificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child(userIdentification).observe(.value, with: { snapshot in
            var groups: [UserInfoFirebase] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let group = UserInfoFirebase(snapshot: snapshot) {
                    groups.append(group)
                }
            }
            self.groups = groups
            self.tableView.reloadData()
        })
//        groups = RealmProvider.get(AddGroupRealm.self)
    }


//     отписываемся
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        notificationToken?.invalidate()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
       return groups.count
//        return groups?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsCell else { return UITableViewCell() }
        //        обращаясь к имени ячейки и параметру текст, передаём в неё города из массива
//        guard let groups = groups?[indexPath.row] else { return cell }
//        cell.GroupsLable.text = groups.groupAdd
        let group = groups[indexPath.row]
        cell.GroupsLable.text = group.addGroups
        return cell
    }
 
    @IBAction func unwindAndAddGroup(segue: UIStoryboardSegue) {
//проверяем соответствие
        if segue.identifier == "AddGroupSegueIdentifier" {
//            если соответствует, то её источник- AllGroupsTableViewController
// создали переменную allGroupsVC хранящую контроллер AllGroupsTableViewController
            let allGroupsVC = segue.source as! AllGroupsTableViewController
//            через allGroupsVC обращаемся к таблице
            if let indexPath = allGroupsVC.AllGroupsTableView.indexPathForSelectedRow {
//                выбранный город кладем в- let group
//                let group = String(allGroupsVC.allGroups![indexPath.row].name)
                let group = UserInfoFirebase(id: allGroupsVC.allGroups![indexPath.row].id, addGroups: allGroupsVC.allGroups![indexPath.row].name)
                
// self.ref.child("users").child(user.uid).setValue(["username": username])
// self.ref.child("users/\(user.uid)/username").setValue(username)
                
                let groupRef = self.ref.child(userIdentification).child(String(group.id).lowercased())
                groupRef.setValue(group.toAnyObject())
                
//                let group = AddGroupRealm(groupAdd: allGroupsVC.allGroups![indexPath.row].name, groupId: allGroupsVC.allGroups![indexPath.row].id)
                
//                встроенная проверка на повторяемость
//                if !groups.contains(group) {
//                добавляем город
//                    groups.append(group)

//                RealmProvider.saveToRealm(items: [group])
        
//                перезагрузка таблицы
//                tableView.reloadData()

            }
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    
//    <------------------------ удаление свайпом =================>
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
// добавляем удаление города из добавленных сами ---------------------------------
//            groups.remove(at: indexPath.row)
            let group = groups[indexPath.row]
            group.ref?.removeValue()
        }

//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
