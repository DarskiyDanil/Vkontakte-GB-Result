//
//  FriendCellCollectionViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 11.04.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Kingfisher

class FotoFriendCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var PhotoImageFriend: UIImageView!{
        didSet {
            PhotoImageFriend.contentMode = .scaleAspectFill
            PhotoImageFriend.clipsToBounds = true
//            PhotoImageFriend
//            contentView.center = PhotoImageFriend.center
            
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // используем Kingfisher для кеширования картинок
    func configure(with photo: PhotoRealmSwiftyJSON ) {
        let url = URL(string: String(photo.imageUrl))
        self.PhotoImageFriend.kf.setImage(with: url)
    }
    
    
//    func setupViews() {
//        PhotoImageFriend.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
//
//    }
    
}
