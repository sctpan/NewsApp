//
//  WeatherView.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    var cityLabel = UILabel()
    var stateLabel = UILabel()
    var tempLabel = UILabel()
    var weatherLabel = UILabel()
    
    init(city: String) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .red
        layer.cornerRadius = 8
        clipsToBounds = true
        self.frame.size.height = 110
        addCityLabel(city)
    }
    
    func addCityLabel(_ city: String) {
        cityLabel.text = city
        cityLabel.textColor = .white
        self.addSubview(cityLabel)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
