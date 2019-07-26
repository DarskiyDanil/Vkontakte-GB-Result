//
//  OneFriendCollectionViewController.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 09.04.2019Tuesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import RealmSwift

private let reuseIdentifier = "PhotoFriendCell"

class OneFriendCollectionViewController: UICollectionViewController {
    
//    private var token: NotificationToken?
    private var tokenPhoto: NotificationToken?
    private var realm = try! Realm()
    
    static let shared = OneFriendCollectionViewController()
    
    let photoRealmSwiftyJSON = PhotoRealmSwiftyJSON()
    
    var vkoService = VkoService()
    var photoFriendLable = [String]()
    public var photoFriend: Results<PhotoRealmSwiftyJSON>?
    public var idPhoto = SessionSingletone.shared.idFRIEND
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard photoFriendLable == photoFriendLable else {return}
        self.title = String(photoFriendLable.first!)
        
        self.vkoService.requestUsersPhotosAlamofire(ownerId: SessionSingletone.shared.idFRIEND) { [weak self] (photos, error) in
            if error != nil {
                //   передал функцию сообщающую ошибку
                self?.showLoginError()
            }
            // в guard можно вместо self? додобавить , let self =self
            guard let photos = photos, let self = self else { return }
            
            //  сохраняем в хранилище
            
            //            photoFriend = RealmProvider.saveToRealm(items: [photos], update: true)
            PhotoRealmSwiftyJSON.savePhotoRealm(photos, ownerId: String(self.idPhoto))
            
            //  достаём из хранилища
            do {
                self.photoFriend = try PhotoRealmSwiftyJSON.gettPhotoFriendRealm(in: String(self.idPhoto))
                
                //  для асинхронности оборачииваем еслии работаем с url session
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //   подписка на уведомления!!!!!!!!!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tokenPhoto = photoFriend?.observe { [weak self] results in
            switch results {
            case .initial(_):
                self?.collectionView.reloadData()
            case .update(_, _, _, _):
                self?.collectionView.reloadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tokenPhoto?.invalidate()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoFriend?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FotoFriendCollectionCell else {
            return UICollectionViewCell()
        }
        // избавился от ?
        guard let photoFriend = photoFriend else {
            return cell
        }
        cell.configure(with: photoFriend[indexPath.row])
        
        return cell
    }
    
    //    вывод ошибки
    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка сети", message: "данные тю-тю, ковыряй код", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    
    
}
