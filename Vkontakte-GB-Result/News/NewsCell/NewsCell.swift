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
            photoProfil.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var nameProfileUser: UILabel!{
        didSet {
            nameProfileUser.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var newNewsPost: UILabel!{
        didSet {
            newNewsPost.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var newsImage: UIImageView!{
        didSet {
            newsImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var constraintNewsImage: NSLayoutConstraint!
    
    
    func configUser(with news: NewsRealmSwiftyJsone) {
        //        DispatchQueue.main.async {
        self.nameProfileUser.text = String(news.newsName)
        self.newNewsPost.text = String(news.textNews)
        
        let url = URL(string: String(news.imageURL))
        //            if url == nil {
        //                self.newsImage.layoutIfNeeded()
        //                self.animatedHeight()
        //            } else {
        self.newsImage.kf.setImage(with: url, options: [.onlyLoadFirstFrame])
        //            }
        
        let url2 = URL(string: String(news.newsPhoto))
        self.photoProfil.kf.setImage(with: url2)
        //        }
    }
    
    
    func animatedHeight() {
        self.newsImage.layoutIfNeeded()
        UIView.animate(withDuration: 0.0){
            self.newsImage.layoutIfNeeded()
            self.constraintNewsImage.constant = 0
        }
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
    
    
    
    //   отвечает за геометрию
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPhotoProfilFrame()
        setNameProfileUserFrame()
        setNewsPostFrame()
        
    }
    
    private let inset: CGFloat = 10.0
    
    private func setPhotoProfilFrame() {
        let photoProfilWidth: CGFloat = 50
        let photoProfilSize = CGSize(width: photoProfilWidth, height: photoProfilWidth)
        let photoProfilOrigin = CGPoint(x: bounds.midX - photoProfilWidth / 2,
                                        y: bounds.midY - photoProfilWidth / 2)
        photoProfil.frame = CGRect(origin: photoProfilOrigin, size: photoProfilSize)
    }
    
    private func setNameProfileUserFrame() {
        let nameProfileUserSize = countLableSize(text: nameProfileUser.text!, font: nameProfileUser.font)
        let nameProfileUserX = (bounds.width - nameProfileUserSize.width) / 2
        let nameProfileUserFrameOrigin = CGPoint(x: nameProfileUserX, y: inset)
        nameProfileUser.frame = CGRect(origin: nameProfileUserFrameOrigin, size: nameProfileUserSize)
    }
    
    private func setNewsPostFrame() {
        let newsPostSize = countLableSize(text: newNewsPost.text!, font: newNewsPost.font)
        let newNewsPostX = (bounds.width - newsPostSize.width) / 2
        let newNewsPostY =  bounds.height - newsPostSize.height - inset
        
        let newNewsPostFrameOrigin = CGPoint(x: newNewsPostX, y: newNewsPostY)
        newNewsPost.frame = CGRect(origin: newNewsPostFrameOrigin, size: newsPostSize)
    }
    
    private func setNewsImageFrame() {
        
    }
    
    private func countLableSize(text: String, font: UIFont)-> CGSize {
        let maxWidth = bounds.width - 2 * inset
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        let width = rect.size.width
        let height = rect.size.height
        
        let size = CGSize(width: ceil(Double(width)), height: ceil(Double(height)))
        
        return size
    }
    
    
    
    
}

