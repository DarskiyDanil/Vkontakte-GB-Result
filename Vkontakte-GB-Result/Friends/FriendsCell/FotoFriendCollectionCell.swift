//
//  FriendCellCollectionViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 11.04.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
//
import Kingfisher
//
import Alamofire
import RealmSwift

class FotoFriendCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var PhotoImageFriend: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var PhotoLableFriend: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
// используем Kingfisher для кеширования картинок
    func configure(with photo: PhotoRealmSwiftyJSON ) {
            let url = URL(string: String(photo.imageUrl))
            self.PhotoImageFriend.kf.setImage(with: url)        
    }
//    func configure(with photo: [PhotoRealmSwiftyJSON] ) {
//        //        var photos = OneFriendCollectionViewController.shared.photoFriend
//        for i in photo {
//            let url = URL(string: String(i.imageUrl))
//            self.PhotoImageFriend.kf.setImage(with: url)
//        }
//    }
    //    func configure(with photo: Results<PhotoRealmSwiftyJSON>?) {
    //        for i in photo! {
    //
    //
    //        self.PhotoImageFriend.image = UIImage(named: String(i.imageUrl))
    //        }
    //    }
    
    
}
