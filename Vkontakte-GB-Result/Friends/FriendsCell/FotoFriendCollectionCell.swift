//
//  FriendCellCollectionViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 11.04.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Kingfisher
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


//     func animation1() {
//        UIView.animate(withDuration: 1, /*время анимации*/
//            delay: 1,                           /*задержка*/
//            options: [.overrideInheritedCurve, .autoreverse], /*распределение времени*/
//            animations: {
//                self.PhotoImageFriend.alpha = 0
//        }, /**/
//            completion: nil) /*действия после завершения анимации*/
//    }
    
    
}
