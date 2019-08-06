//
//  NewsCell.swift
//  Vkontakte-GB-Result
//
//  Created by Danil Darskiy on 26.06.2019Wednesday.
//  Copyright © 2019 Danil Darskiy-GB-Result. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import RealmSwift

protocol NewsCellDelegate: class {
    func nameProfileUser(to name: String?)
}

class NewsCell: UITableViewCell {

    public weak var delegate: NewsCellDelegate?

    @IBOutlet weak var photoProfil: UIImageView!{
        didSet {
        }
    }

    @IBOutlet weak var nameProfileUser: UILabel!

    @IBOutlet weak var newNewsPost: UILabel!

    @IBOutlet weak var newsImage: UIImageView!{
        didSet {
        }
    }
    

    func configUser(with news: NewsRealmSwiftyJsone) {
        self.nameProfileUser.text = String(news.newsName)
        self.newNewsPost.text = String(news.textNews)
        
        let url = URL(string: String(news.imageURL))
        self.newsImage.kf.setImage(with: url, options: [.onlyLoadFirstFrame])
        
        let url2 = URL(string: String(news.newsPhoto))
        self.photoProfil.kf.setImage(with: url2)

    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

