//
//  NewsService.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/13.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsService {
    var homePageNews: [News]!
    var detailPageNews: News!
    var chartData: [Int]!
    func getHomePageNews() -> [News]{
        return homePageNews
    }
    
    func getDetailPageNews() -> News {
        return detailPageNews
    }
    
    func getChartData() -> [Int]{
        return chartData
    }
    
    func getChartDataHelper(keyword: String) {
        AF.request(Constants.backendUrl + "news/trend", parameters: ["keyword": keyword]).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let data = try JSON(data: response.data!)
                    self.chartData = data["data"].arrayValue.map{ $0.intValue}
                    NotificationCenter.default.post(name: Constants.chartDataReady, object: nil)
                } catch {
                    print("can't convert to json")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getDetailPageNewsHelper(id: String) {
        detailPageNews = News()
        AF.request(Constants.backendUrl + "news/guardian/article", parameters: ["id": id]).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let news = try JSON(data: response.data!)
                    self.detailPageNews.id = news["news"]["id"].stringValue
                    self.detailPageNews.date = news["news"]["date"].stringValue
                    self.detailPageNews.section = news["news"]["section"].stringValue
                    self.detailPageNews.title = news["news"]["title"].stringValue
                    self.detailPageNews.shareUrl = news["news"]["shareUrl"].stringValue
                    self.detailPageNews.image = news["news"]["image"].stringValue
                    self.detailPageNews.description = news["news"]["description"].stringValue
                    NotificationCenter.default.post(name: Constants.detailNewsReady, object: nil)
                } catch {
                    print("can't convert to json")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
    
    func getHomePageNewsHelper() {
        homePageNews = [News]()
        AF.request(Constants.backendUrl + "news/guardian/newest").responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let json = try JSON(data: response.data!)
                    for (_, news): (String, JSON) in json["news"] {
                        let current = News()
                        current.id = news["id"].stringValue
                        current.date = news["date"].stringValue
                        current.section = news["section"].stringValue
                        current.title = news["title"].stringValue
                        current.shareUrl = news["shareUrl"].stringValue
                        current.timeDiff = news["timeDiff"].stringValue
                        current.image = news["image"].stringValue
                        self.homePageNews.append(current)
                    }
                    NotificationCenter.default.post(name: Constants.homeNewsReady, object: nil)
                } catch {
                    print("can't convert to json")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
