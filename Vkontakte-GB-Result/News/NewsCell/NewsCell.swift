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
            //            {
            //                [weak self] (news, error) in
            //                if error != nil {
            //                    //   передал функцию сообщающую ошибку
            //                    print("error")
            //                }
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
    
    
    
    
    
    
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
    //
    //
    //    //  переопределяю метод расчёта позиции
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        PhotoProfilFrame()
    //        NameProfileUserFrame()
    //        NewsPostFrame()
    //        NewsImageFrame()
    //    }
    //    func setNameProfileUser(text: String) {
    //        nameProfileUser.text = text
    //        NameProfileUserFrame()
    //    }
    //    func setNewsPost (text: String) {
    //        newNewsPost.text = text
    //        NewsPostFrame()
    //    }
    //
    //
    //
    //    //    настройка фреймы
    //    private let inset: CGFloat = 10.0
    //
    //    private func PhotoProfilFrame() {
    //        let photoProfilWidth: CGFloat = 50
    //        let photoProfilSize = CGSize(width: photoProfilWidth, height: photoProfilWidth)
    //        let photoProfilOrigin = CGPoint(x: bounds.midX - photoProfilWidth / 2,
    //                                        y: bounds.midY - photoProfilWidth / 2)
    //        photoProfil.frame = CGRect(origin: photoProfilOrigin, size: photoProfilSize)
    //    }
    //    //    имя публикующего
    //    private func NameProfileUserFrame() {
    //        // получаем размер текста, передавая сам текст и шрифт
    //        let nameProfileUserSize = countLableSize(text: nameProfileUser.text!, font: nameProfileUser.font)
    //        // координата по оси X
    //        let nameProfileUserX = (bounds.width - nameProfileUserSize.width) / 2
    //        // получаем точку верхнего левого угла надписи
    //        let nameProfileUserFrameOrigin = CGPoint(x: nameProfileUserX, y: inset)
    //        // получаем фрейм и устанавливаем его UILabel
    //        nameProfileUser.frame = CGRect(origin: nameProfileUserFrameOrigin, size: nameProfileUserSize)
    //    }
    //    //    текст публикации
    //    private func NewsPostFrame() {
    //        let newsPostSize = countLableSize(text: newNewsPost.text!, font: newNewsPost.font)
    //        let newNewsPostX = (bounds.width - newsPostSize.width) / 2
    //        let newNewsPostY =  bounds.height - newsPostSize.height - inset
    //
    //        let newNewsPostFrameOrigin = CGPoint(x: newNewsPostX, y: newNewsPostY)
    //        newNewsPost.frame = CGRect(origin: newNewsPostFrameOrigin, size: newsPostSize)
    //    }
    //
    //    private func NewsImageFrame() {
    //        let newsImageWidth: CGFloat = 375
    //        let newsImageSize = CGSize(width: newsImageWidth, height: newsImageWidth)
    //        let newsImageOrigin = CGPoint(x: bounds.midX - newsImageWidth / 2,
    //                                      y: bounds.midY - newsImageWidth / 2)
    //        newsImage.frame = CGRect(origin: newsImageOrigin, size: newsImageSize)
    //    }
    //    //     размер прямогуольника текстом
    //    private func countLableSize(text: String, font: UIFont)-> CGSize {
    //        let maxWidth = bounds.width - 2 * inset
    //        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
    //        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
    //        let width = Double(rect.size.width)
    //        let height = Double(rect.size.height)
    //        let size = CGSize(width: ceil(width), height: ceil(height))
    //        return size
    //    }
    
    
    
    
    
    
    
    
}

