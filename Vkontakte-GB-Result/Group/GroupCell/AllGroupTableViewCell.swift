//
//  AllGroupTableViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 10.04.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit

class AllGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var AllGroupNameLable: UILabel!
    
    @IBOutlet weak var groupAvatar: UIImageView!{
        didSet {
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with group: GroupsRealmSwiftyJSON) {
        self.AllGroupNameLable.text = String(group.name)
        
        let url = URL(string: String(group.imageUrl))
        self.groupAvatar.kf.setImage(with: url)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
