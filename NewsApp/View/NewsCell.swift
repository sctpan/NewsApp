//
//  NewsCell.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import Toast_Swift

class NewsCell: UITableViewCell {
    var newsTitleLabel = UILabel()
    var timeLabel = UILabel()
    var sectionLabel = UILabel()
    var bookmarkBtn = UIButton()
    var imgThumb = UIImageView(frame: CGRect(x:0, y:0, width: 130, height: 130))
    var news: News!
    var parentView: UIView!
    let backGroundColor: UIColor = UIColor( red: CGFloat(239/255.0), green: CGFloat(239/255.0), blue: CGFloat(239/255.0), alpha: CGFloat(1.0))
    let borderColor: UIColor = UIColor( red: CGFloat(191/255.0), green: CGFloat(191/255.0), blue: CGFloat(191/255.0), alpha: CGFloat(1.0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = backGroundColor
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addThumbNail()
        
        addTitleLabel()
        addTimeLabel()
        addSectionLabel()
        addBookmarkBtn()
    }
    
    func set(news: News, _ parentView: UIView) {
        self.news = news
        self.parentView = parentView
        newsTitleLabel.text = self.news.title
        timeLabel.text = self.news.timeDiff
        sectionLabel.text = "| " + self.news.section
        if self.news.image == "unavailable" {
            imgThumb.image = #imageLiteral(resourceName: "default-guardian")
        } else {
            let url = URL(string: self.news.image)
            let data = try? Data(contentsOf: url!)
            imgThumb.image = UIImage(data: data!)
        }
        if StoreService.get(key: self.news.id) != nil {
           bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
           bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBookmarkBtn() {
        bookmarkBtn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        addSubview(bookmarkBtn)
        bookmarkBtn.translatesAutoresizingMaskIntoConstraints = false
        bookmarkBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
//        bookmarkBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        bookmarkBtn.centerYAnchor.constraint(equalTo: sectionLabel.centerYAnchor, constant: 0).isActive = true
    }
    
    @objc func buttonClicked() {
        if StoreService.get(key: self.news.id) != nil {
            StoreService.remove(key: self.news.id)
            bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            self.parentView.makeToast(Constants.bookmarkRemoveMessage)
        } else {
            StoreService.store(key: self.news.id, news: self.news)
            bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            self.parentView.makeToast(Constants.bookmarkSaveMessage)
        }
    }
    
    func addSectionLabel() {
        sectionLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
    }
    
    func addThumbNail() {
        imgThumb.contentMode = .scaleAspectFill
        imgThumb.clipsToBounds = true
        imgThumb.layer.cornerRadius = 8
        addSubview(imgThumb)
//        imgThumb.translatesAutoresizingMaskIntoConstraints = false
//        imgThumb.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
//        imgThumb.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
//        imgThumb.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func addTimeLabel() {
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: imgThumb.trailingAnchor, constant: 10).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func addTitleLabel() {
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        newsTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        newsTitleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: imgThumb.trailingAnchor, constant: 10).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
    }
}
