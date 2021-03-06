//
//  WeatherService.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/12.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherService: NSObject{
    var locationManager = CLLocationManager()
    var weatherInfo = Weather()
    
    
    override init() {
        super.init()
        UserDefaults.standard.set(["base"], forKey: "AppleLanguages")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()) {
            print("init locationManager")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    func getInfo() {
        locationManager.startUpdatingLocation()
    }
    
    func getLocation(_ location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error -> Void in
            guard let placemark = placemarks?.first else {return}
            self.weatherInfo.city = placemark.locality ?? ""
            self.weatherInfo.state = placemark.administrativeArea ?? ""
            let country = placemark.isoCountryCode ?? ""
            if(country == "US") {
                self.weatherInfo.state = Constants.statesDictionary[self.weatherInfo.state] ?? self.weatherInfo.state
            }
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            self.getWeatherInfo()
        })
        
    }
    func getWeather() -> Weather{
        return weatherInfo
    }
    
    func getWeatherInfo() {
        let parameters = ["appid": Constants.weatherApiKey, "units":"metric", "q": self.weatherInfo.city]
        AF.request(Constants.weatherUrl, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let json = try JSON(data: response.data!)
                    self.weatherInfo.temperature = String(Int(round(json["main"]["temp"].floatValue))) + "°C"
                    self.weatherInfo.weather = json["weather"][0]["main"].stringValue
                    NotificationCenter.default.post(name: Constants.weatherDataReady, object: nil)
                } catch {
                    print("can't convert to json")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension WeatherService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location updated")
        manager.stopUpdatingLocation()
        let location = locations[0]
        print("location: \(location)")
        getLocation(location)
    }
}
