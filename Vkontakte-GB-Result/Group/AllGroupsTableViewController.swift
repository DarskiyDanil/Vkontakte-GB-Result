//
//  AllGroupsTableViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 09.04.2019Tuesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import RealmSwift

class AllGroupsTableViewController: UITableViewController {
    
    @IBOutlet weak var SearchBarGroup: UISearchBar!
    @IBOutlet weak var AllGroupsTableView: UITableView! {
        didSet {
            AllGroupsTableView.delegate = self
            AllGroupsTableView.dataSource = self
        }
    }
    private var notificationAllGroupsToken: NotificationToken?
    var vkoService = VkoService()
    var allGroups: Results<GroupsRealmSwiftyJSON>?
    
    
    override func viewDidLoad() {
//        SearchBarGroup.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(userHasJoinedGroup(_:)), name: NSNotification.Name("userHasJoinedGroup"), object: nil)
    
        
        
        super.viewDidLoad()
        SearchBarGroup.delegate = self
        requestSession()

    }
    
//    @objc func userHasJoinedGroup(_ notification: Notification) {
//        // TODO: Some pause to show updated information about groups right after subscription
//        navigationController?.popViewController(animated: true)
//    }

    
    override func viewWillAppear(_ animated: Bool) {
//        уведомления
        notificationAllGroupsToken = self.allGroups?.observe { [weak self] results in
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
        notificationAllGroupsToken?.invalidate()
    }
    
// сетевой запрос
    private func requestSession() {
        // [weak self] позволяет сделать ссылки на объект разрываемыми
        self.vkoService.requestUsersGroupsAlamofire() { [weak self] (groups, error) in
            if error != nil {
                //   передал функцию сообщающую ошибку
                self?.showLoginError()
            }
            // в guard можно вместо self? додобавить , let self =self
            guard let groups = groups, let self = self else { return}
//            self?.allGroups = groups

            //  сохраняем в хранилище
            GroupsRealmSwiftyJSON.saveGroupsRealm(groups)

            // достаём из хранилища
            do {
                self.allGroups = try GroupsRealmSwiftyJSON.getGroupsRealm()

            //  для асинхронности оборачииваем
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
                    print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // возвращаем ячейки по количеству городов в массиве (groups.count)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups?.count ?? 0
    }
    
    //    проверка: если может в ячейку по идентифаеру то передаёт, иначе возвращает пустую ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as? AllGroupTableViewCell else {
            return UITableViewCell()
        }
        //        обращаясь к имени ячейки и параметру текст, передаём в неё города из массива
        // избавился от ?
        guard let allGroups = allGroups else {
            return cell
        }
        cell.configure(with: allGroups[indexPath.row])
        // Configure the cell...
        
        return cell
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
    }    /*
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
    
}

extension AllGroupsTableViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // If text did change but there is still something to search for - execute search
//        if searchText != "" {
//            APIService.instance.searchGroupsByName(searchName: searchText) { [weak self] allGroups in
//                self?.allGroups = allGroups
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self?.tableView.reloadData()
//                }
//            }
//        } else {
//            self.allGroups.
//            self.tableView.reloadData()
//        }
//    }
}


