//
//  FriendsTableViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 08.04.2019Monday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import Firebase
import FirebaseFirestore


class FriendsTableViewController: UITableViewController {
    var oneFriendCollectionViewController = OneFriendCollectionViewController()
    
//    @IBAction func logoutPressed(_ sender: AnyObject) {
//        do {
//            try Auth.auth().signOut()
//            self.dismiss(animated: true, completion: nil)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    @IBOutlet weak var PhotosFriendTableView: UITableView! {
        didSet {
            PhotosFriendTableView.delegate = self
            PhotosFriendTableView.dataSource = self
        }
    }
    private var notificationFriendToken: NotificationToken?
    private var allFriendPhoto = [PhotoRealmSwiftyJSON]()
    private var allFriend: Results<FriendsRealmSwiftyJSON>?
    private let vkoService = VkoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [weak self] позволяет сделать ссылки на объект разрываемыми
        self.vkoService.requestUsersFriendsAlamofire() { [weak self] (friends, error) in
            if error != nil {
                //   передал функцию сообщающую ошибку
                self?.showLoginError()
            }
            // в guard можно вместо self? додобавить , let self = self
            guard let friends = friends, let self = self else { return}
            
//  сохраняем в хранилище
            RealmProvider.saveToRealm(items: friends)
//            FriendsRealmSwiftyJSON.saveFriendsRealm(friends)
// достаём из хранилища
            do {
                self.allFriend = try FriendsRealmSwiftyJSON.getFriendsRealm()
//            
//  для асинхронности оборачииваем
            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        notificationFriendToken = self.allFriend?.observe { [weak self] results in
            switch results {
            case .initial(_):
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    //     отписываемся
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            notificationFriendToken?.invalidate()
        }
  
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allFriend?.count ?? 0
    }
    
    //    проверка: если может в ячейку по идентифаеру то передаёт, иначе возвращает пустую ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsTableViewCell else {
            return UITableViewCell()
        }
        
        // Configure the cell...
        //        cell.FriendsNameLable.text = String(allFriend[indexPath.row].description)
        // избавился от ?
        guard let allFriend = allFriend else {
            return cell
        }
        cell.configure(with: allFriend[indexPath.row])
        
        return cell
    }
    // MARK: - передача информации по сеге при нажатии ---
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentPhotoSegueIdentifier" {
//            контроллер на который переходим
            let friendLablePhotoVC = segue.destination as! OneFriendCollectionViewController
            // при нажатии на ячейку, при помощи indexPathForSelectedRow отправляем данные из ячейки
            if let indexPath = PhotosFriendTableView.indexPathForSelectedRow {
                //                выбранную ячейку сохраняем в переменную
                let friend = String(allFriend![indexPath.row].firstName + " " + allFriend![indexPath.row].lastName)
                
                let idFriend = String(allFriend![indexPath.row].id)
                
//                передаю id в функцию requestUsersPhotosAlamofire
//                vkoService.requestUsersPhotosAlamofire(ownerId: idFriend)
                SessionSingletone.shared.idFRIEND = idFriend
                //  передаю в пустой массив выбранную ячейку из друзей
                friendLablePhotoVC.photoFriendLable.append(friend)

                
                //                }
//               let friendPhotos = String(allFriendPhoto[indexPath.row].imageUrl)
//                friendLablePhotoVC.photoFriend.append(friendPhotos)
            }
        }
    }
    
    
    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка сети", message: "данные неполучены, ковыряй код", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    //}
    //func shouldPerformSegue(withIdentifier identifier: "PresentPhotoSegueIdentifier", sender: Any?) -> Bool {
    //    // Проверяем данные
    //
    //
    //    // Вернем результат
    //    return true
    //}
    
}

