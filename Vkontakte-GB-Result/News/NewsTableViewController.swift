//
//  NewsTableViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 26.06.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.

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
    var newsCell = NewsCell()
    private var notificationNewsToken: NotificationToken?
    var news: Results<NewsRealmSwiftyJsone>?
    //    идентификаторы ячеек
    var cellWithPhotoAndText = "NewsCellIdentifier"
    var cellWithText = "NewsCellTextIdentifier"
    
    var newsService = NewsService()
    
    //   обновление новостей свайпом вниз
    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        refreshControl?.attributedTitle = NSAttributedString(string: "обновляю")
        refreshControl?.tintColor = .blue
        refreshControl?.addTarget(self, action: #selector(refreshNewsList(_:)), for: .valueChanged)
    }
    @objc private func refreshNewsList(_ sender: Any) {
        requestNewsSession()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        addRefreshControl()
        requestNewsSession()
//        pairTableAndRealm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        pairTableAndRealm()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pairTableAndRealm()
        
    }
    
    //        уведомления
    func pairTableAndRealm() {
        //        guard let realm = try? Realm() else {
        //            return
        //        }
        //        news = realm.objects(NewsRealmSwiftyJsone.self)
        
        guard let realm = try? Realm() else {return}
        news = realm.objects(NewsRealmSwiftyJsone.self)
        
        notificationNewsToken = self.news?.observe { [weak self] (results: RealmCollectionChange) in

            guard let tableView = self?.tableView else{return}
            
            switch results {
//            case .initial(_):
//                self?.tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
//            //                            self?.tableView.reloadData()
//            case .error(let error):
//                print(error.localizedDescription)
//            }
//            self?.tableView.reloadData()
               
//                ---------------------------------------
            case .initial:
                tableView.reloadData()
            case.update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with:  .automatic)
                self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),  with: .automatic)
                self?.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
//            tableView.reloadData()
//            -----------------------------------------------
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
            guard let news = news, let self = self else { return }
            //            self?.allGroups = groups
            //  сохраняем в хранилище
            NewsRealmSwiftyJsone.saveNewsRealm(news)
            //            RealmProvider.saveToRealm(items: news)
            // достаём из хранилища
            do {
                self.news = try NewsRealmSwiftyJsone.getNewsRealm()
                //                self.news = RealmProvider.get(NewsRealmSwiftyJsone.self)
                //  для асинхронности оборачииваем
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //    вывод ошибки
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
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if news?.count == 0 {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
        return news?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let news = news else {
            return UITableViewCell()
        }
        if news[indexPath.row].imageURL.isEmpty  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellWithText) as? NewsCellText else { return UITableViewCell() }
//            guard let news = news else {
//                return cell
//            }
           
            cell.configUser(with: news[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellWithPhotoAndText) as? NewsCell else { return UITableViewCell() }
//            guard let news = news else {
//                return cell
//            }
           
            cell.configUser(with: news[indexPath.row])
            return cell
            
        }
        
    }
    
    
    
}
