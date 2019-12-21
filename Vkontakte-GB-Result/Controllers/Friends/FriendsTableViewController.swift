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
    let friendsTableViewCell = FriendsTableViewCell()
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
        requestUsersFriendsSession()
        pairTableAndRealm()
    }
    
    private func requestUsersFriendsSession() {
        // [weak self] позволяет сделать ссылки на объект разрываемыми
        self.vkoService.requestUsersFriendsAlamofire() { [weak self] (friends, error) in
            if error != nil {
                //   передал функцию сообщающую ошибку
                self?.showLoginError()
            }
            // в guard можно вместо self? додобавить , let self = self
            guard let friends = friends, let self = self else { return}
            
            //  сохраняем в хранилище
            //           RealmProvider.saveToRealm(items: friends)
            FriendsRealmSwiftyJSON.saveFriendsRealm(friends)
            
            // достаём из хранилища
            do {
                self.allFriend = try FriendsRealmSwiftyJSON.getFriendsRealm()
                //                 self.allFriend = realm.objects(FriendsRealmSwiftyJSON.self)
                //                self.allFriend = RealmProvider.get( FriendsRealmSwiftyJSON.self)
                
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
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 0.5, animations: {
//            self.friendsTableViewCell.FriendsNameLable.bounds.origin.x += 2
//        })
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else {return}
        allFriend = realm.objects(FriendsRealmSwiftyJSON.self)
        
        notificationFriendToken = self.allFriend?.observe { [weak self] (results: RealmCollectionChange) in
            guard let tableView = self?.tableView else{return}
            switch results {
            case .initial(_):
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
                self?.tableView.reloadData()
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
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
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
                SessionSingletone.shared.idFRIEND = idFriend
                //  передаю в пустой массив выбранную ячейку из друзей
                friendLablePhotoVC.photoFriendLable.append(friend)
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
    
}

