//
//  NewsTableViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 26.06.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {

        @IBOutlet weak var newsTableView: UITableView! {
                didSet {
        //             назначил таблицу делегатом
                    newsTableView.delegate = self
        //            протокол для определения данных таблицы
                    newsTableView.dataSource = self
                }
            }
    
    private var notificationNewsToken: NotificationToken?
    var news: Results<NewsRealmSwiftyJsone>?
    var newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

requestNewsSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        уведомления
        notificationNewsToken = self.news?.observe { [weak self] results in
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
        notificationNewsToken?.invalidate()
    }
    
    //  запрос
    private func requestNewsSession() {
        // [weak self] позволяет сделать ссылки на объект разрываемыми
        self.newsService.requestNewsAlamofire() { [weak self] (news, error) in
            if error != nil {
                //   передал функцию сообщающую ошибку
                self?.showLoginError()
            }
            // в guard можно вместо self? додобавить , let self =self
            guard let news = news, let self = self else { return}
            //            self?.allGroups = groups
            
            //  сохраняем в хранилище
            NewsRealmSwiftyJsone.saveNewsRealm(news)
            
            // достаём из хранилища
            do {
                self.news = try NewsRealmSwiftyJsone.getNewsRealm()
                
                //  для асинхронности оборачииваем
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
   
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellIdentifier"/*, for: indexPath*/) as? NewsCell

            else {
            return UITableViewCell()
        }
        /*if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "NewsCellIdentifier") as? NewsCell
        }*/
        guard let news = news else {
            return cell
        }
        
        cell.configUser(with: news[indexPath.row])
        

        
        return cell
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

}
