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
        requestphotoFriendSession()
        pairTableAndRealm()
    }
    
    private func requestphotoFriendSession() {
        guard photoFriendLable == photoFriendLable else {return}
        self.title = String(photoFriendLable.first!)
        self.vkoService.requestUsersPhotosAlamofire(ownerId: SessionSingletone.shared.idFRIEND) { [weak self] (photos, error) in
            if error != nil {
                //   передал функцию сообщающую ошибку
                self?.showLoginError()
            }
            guard let photos = photos, let self = self else { return }
            //  сохраняем в хранилище
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //   подписка на уведомления об обновлении!
    func pairTableAndRealm() {
        
        guard let realm = try? Realm() else {return}
        
        photoFriend = realm.objects(PhotoRealmSwiftyJSON.self)
        tokenPhoto = self.photoFriend?.observe { [weak self] (changes: RealmCollectionChange) in
            
            guard let collectionView = self?.collectionView else {return}
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                print("инициир")
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({IndexPath(row: $0, section: 0) }))
                }, completion: nil)
                print("обновился")
            case .error(let error):
                print("ошибка")
                fatalError("\(error)") }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tokenPhoto?.invalidate()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoFriend?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FotoFriendCollectionCell else {return UICollectionViewCell()}
        guard let photoFriend = photoFriend else {return cell}
        cell.configure(with: photoFriend[indexPath.row])
        return cell
    }
    
    //   метод вывода ошибки
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

extension OneFriendCollectionViewController: UICollectionViewDelegateFlowLayout {
    //    размер ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsCountInRow: CGFloat = 3
        let fillingWidth: CGFloat = 8 * (itemsCountInRow + 1)
        let availableWidthForItems: CGFloat = collectionView.frame.width - fillingWidth
        let widthForItem: CGFloat = availableWidthForItems / itemsCountInRow
        return CGSize(width: widthForItem, height: widthForItem)
    }
    
    //    отступы ячеек от краёв
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    //    минимальный межстрочный интервал
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    //    минимальный строчный интервал между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
}
