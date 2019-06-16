//
//  FriendsTableViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 11.04.2019Thursday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
//делегат FriendsNameLable
protocol FriendsTableViewCellDelegate: class {
    func FriendsNameLable(to name: String?)
}

class FriendsTableViewCell: UITableViewCell {
// ссылка на делегат
    public weak var delegate: FriendsTableViewCellDelegate?
    
    @IBOutlet weak var FriendsNameLable: UILabel!
//    {
//        delegate?.FriendsNameLable(to: self.FriendsNameLable.text)
//    }

//    private var dateFormarter: DateFormatter {
//
//    }
     func configure(with friend: FriendsRealmSwiftyJSON) {
        self.FriendsNameLable.text = String(friend.firstName + " " + friend.lastName)

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
