//
//  NewsCell.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    var newsTitleLabel = UILabel()
    
    let backGroundColor: UIColor = UIColor( red: CGFloat(239/255.0), green: CGFloat(239/255.0), blue: CGFloat(239/255.0), alpha: CGFloat(1.0))
    let borderColor: UIColor = UIColor( red: CGFloat(191/255.0), green: CGFloat(191/255.0), blue: CGFloat(191/255.0), alpha: CGFloat(1.0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = backGroundColor
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
        addSubview(newsTitleLabel)
        setTitleLabelConstraints()
    }
    
    func set(news: News) {
        newsTitleLabel.text = news.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleLabelConstraints() {
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        newsTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
}
