//
//  FriendsTableViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 11.04.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Kingfisher

protocol FriendsTableViewCellDelegate: class {
    func FriendsNameLable(to name: String?)
}

class FriendsTableViewCell: UITableViewCell {
    static let friendsTableViewCell = FriendsTableViewCell()
    
    public weak var delegate: FriendsTableViewCellDelegate?
    
    @IBOutlet weak var avatarFriend: UIImageView! {
        didSet {
            avatarFriend.layer.cornerRadius = avatarFriend.frame.size.height/4
        }
    }
    
    @IBOutlet weak var FriendsNameLable: UILabel!{
        didSet {
            
        }
    }

    func configure(with friend: FriendsRealmSwiftyJSON) {
        self.FriendsNameLable.text = String(friend.firstName + " " + friend.lastName)
        
        let url = URL(string: String(friend.imageUrl))
        self.avatarFriend.kf.setImage(with: url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
}
