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
    
    init(weatherInfo: Weather) {
        super.init(frame: UIScreen.main.bounds)
        layer.cornerRadius = 8
        clipsToBounds = true
        self.frame.size.height = 110
        setBackgroundImage(weatherInfo.weather)
        addCityLabel(weatherInfo.city)
        addStateLabel(weatherInfo.state)
        addTempLabel(weatherInfo.temperature)
        addWeatherLabel(weatherInfo.weather)
    }
    
    func setBackgroundImage(_ weather: String) {
        self.contentMode = UIView.ContentMode.scaleToFill
        switch weather {
        case "Clouds":
         //  self.backgroundColor = UIColor(patternImage: UIImage(named: "cloudy_weather")!)
            self.layer.contents = UIImage(named:"cloudy_weather")?.cgImage
        case "Clear":
           
            self.layer.contents = UIImage(named:"clear_weather")?.cgImage
        //    self.backgroundColor = UIColor(patternImage: UIImage(named: "clear_weather")!)
        case "Snow":
            self.layer.contents = UIImage(named:"snowy_weather")?.cgImage
        //    self.backgroundColor = UIColor(patternImage: UIImage(named: "snowy_weather")!)
        case "Rain":
            self.layer.contents = UIImage(named:"rainy_weather")?.cgImage
        //    self.backgroundColor = UIColor(patternImage: UIImage(named: "rainy_weather")!)
        case "Thunderstorm":
            self.layer.contents = UIImage(named:"thunder_weather")?.cgImage
         //   self.backgroundColor = UIColor(patternImage: UIImage(named: "thunder_weather")!)
        default:
            self.layer.contents = UIImage(named:"sunny_weather")?.cgImage
        //    self.backgroundColor = UIColor(patternImage: UIImage(named: "sunny_weather")!)
        }
    }
    
    func addCityLabel(_ city: String) {
        cityLabel.text = city
        cityLabel.font = UIFont.boldSystemFont(ofSize: 24)
        cityLabel.textColor = .white
        self.addSubview(cityLabel)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
    }
    
    func addStateLabel(_ state: String) {
        stateLabel.text = state
        stateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stateLabel.textColor = .white
        self.addSubview(stateLabel)
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        stateLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20).isActive = true
        
    }
    
    func addTempLabel(_ temp: String) {
        tempLabel.text = temp
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tempLabel.textColor = .white
        self.addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        tempLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
    }
    
    func addWeatherLabel(_ weather: String) {
        weatherLabel.text = weather
        weatherLabel.font = UIFont.boldSystemFont(ofSize: 20)
        weatherLabel.textColor = .white
        self.addSubview(weatherLabel)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        weatherLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 20).isActive = true
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
