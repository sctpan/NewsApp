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
    var homePageNews = [News]()
    init(target: String) {
        switch target {
        case "homeNews":
            getHomePageNewsHelper()
        default:
            getHomePageNewsHelper()
        }
    }
    
    
    func getHomePageNews() -> [News]{
        return homePageNews
    }
    
    func getHomePageNewsHelper() {
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
