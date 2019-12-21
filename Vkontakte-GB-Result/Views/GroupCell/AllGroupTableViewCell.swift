//
//  AllGroupTableViewCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 10.04.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//
import Kingfisher
import UIKit

class AllGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var AllGroupNameLable: UILabel!
    
    @IBOutlet weak var groupAvatar: UIImageView! {
        didSet {
            groupAvatar.layer.cornerRadius = groupAvatar.frame.size.height/4
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
    
    func animationAllGroup() {
        UIView.animate(withDuration: 1, /*время анимации*/
            delay: 1,                           /*задержка*/
            options: [.autoreverse], /*распределение времени*/
            animations: {
                self.AllGroupNameLable.alpha = 0.5
        }, /**/
            completion: nil) /*действия после завершения анимации*/
    }
    
}
