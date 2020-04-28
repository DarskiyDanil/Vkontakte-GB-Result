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
    var post_id: Int!
    var owner_id: String!
    
    @IBOutlet weak var photoProfil: UIImageView!{
        didSet {
            //            photoProfil.translatesAutoresizingMaskIntoConstraints = false
            photoProfil.layer.cornerRadius = photoProfil.frame.size.height/4
        }
    }
    
    @IBOutlet weak var nameProfileUser: UILabel!{
        didSet {
            //            nameProfileUser.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var newNewsPost: UILabel!{
        didSet {
            //            newNewsPost.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var newsImage: UIImageView!{
        didSet {
            //            newsImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var newsImageHeight: NSLayoutConstraint!
    @IBOutlet weak var newsImageWidth: NSLayoutConstraint!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    
    @IBAction func likesButtonPressed(_ sender: Any) {
        if likesButton.titleColor(for: .normal) == UIColor.likedIconColor {
            NewsService.newsService.changeNumberOfLikesNews(post_id, ownerId: owner_id, action: "delete")
            likesButton.setImage(#imageLiteral(resourceName: "likeIconNotSelected"), for: .normal)
            likesButton.setTitleColor(UIColor.notLikedIconColor, for: .normal)
            
        } else {
            NewsService.newsService.changeNumberOfLikesNews(post_id, ownerId: owner_id, action: "add")
            likesButton.setImage(#imageLiteral(resourceName: "likeIconSelected"), for: .normal)
            likesButton.setTitleColor(UIColor.likedIconColor, for: .normal)
            //            lnewsRealmSwiftyJsoneikesButton.setTitle("\(newsRealmSwiftyJsone.likesCount)", for: .normal)
        }
    }
    
    var newsRealmSwiftyJsone = NewsRealmSwiftyJsone()
    
    func configUser(with news: NewsRealmSwiftyJsone) {
        
        self.nameProfileUser.text = String(news.newsName)
        self.newNewsPost.text = String(news.textNews)
        //        setNameProfileUser(text: String(news.newsName))
        //        setNewsPost(text: String(news.textNews))
        
        let screenSize = UIScreen.main.bounds
        newsImageWidth.constant = screenSize.width - 20
        let aspectRatio = newsImageWidth.constant / CGFloat(news.imageWidth)
        newsImageHeight.constant = CGFloat(news.imageHeight) * aspectRatio
        
        let url = URL(string: String(news.imageURL))
        self.newsImage.kf.setImage(with: url, options: [.onlyLoadFirstFrame])
        
        let url2 = URL(string: String(news.newsPhoto))
        self.photoProfil.kf.setImage(with: url2)
        
        self.commentButton.setTitle("\(news.commentsCount)", for: .normal)
        self.repostButton.setTitle("\(news.repostsCount)", for: .normal)
        self.viewsButton.setTitle("\(news.views)", for: .normal)
        self.likesButton.setTitle("\(news.likesCount)", for: .normal)
        
        if news.userLikes == 1 {
            likesButton.setImage(#imageLiteral(resourceName: "likeIconSelected"), for: .normal)
            likesButton.setTitleColor(UIColor.likedIconColor, for: .normal)
        }
        post_id = news.postId
        owner_id = String(news.sourceId)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        likesButton.setImage(#imageLiteral(resourceName: "likeIconNotSelected"), for: .normal)
        likesButton.setTitleColor(UIColor.notLikedIconColor, for: .normal)
        likesButton.setTitle("\(newsRealmSwiftyJsone.likesCount)", for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
    
    
}

