//
//  StoreService.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/13.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation

class StoreService {
    
    static func store(key: String, news: News) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(news) {
            defaults.set(encoded, forKey: key)
            var newsList = getNewsList()
            newsList.append(news);
            let newsListJson = try? encoder.encode(newsList)
            defaults.set(newsListJson!, forKey: "news")
        }
    }
    
    static func getNewsList() -> [News]{
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if ((defaults.object(forKey: "news") as? Data) != nil) {
            let newsListJson = defaults.object(forKey: "news") as! Data
            let newsList = try? decoder.decode([News].self, from: newsListJson)
            if(newsList == nil) {
                return [News]()
            } else {
                return newsList!
            }
        } else {
            return [News]()
        }
    }
    
    static func get(key: String) -> News? {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if((defaults.object(forKey: key) as? Data) != nil) {
            let newsJson = defaults.object(forKey: key) as! Data
            if let news = try? decoder.decode(News.self, from: newsJson) {
//                print("news returned")
                return news
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func remove(key: String) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        defaults.removeObject(forKey: key)
        var newsList = getNewsList()
        var removeIndex = -1
        if(newsList.count > 0) {
            for index in 0...newsList.count - 1 {
                if(newsList[index].id == key) {
                    removeIndex = index
                }
            }
            if removeIndex != -1 {
                newsList.remove(at: removeIndex)
            }
        }
        let newsListJson = try? encoder.encode(newsList)
        defaults.set(newsListJson!, forKey: "news")
    }
    
    static func clearAllNews() {
        let newsList = getNewsList()
        if(newsList.count > 0) {
            for index in 0...newsList.count - 1 {
                remove(key: newsList[index].id)
            }
        }
        UserDefaults.standard.removeObject(forKey: "news")
    }
}
