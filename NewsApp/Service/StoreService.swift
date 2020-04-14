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
//            print("news saved")
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
        defaults.removeObject(forKey: key)
//        print("news removed")
    }
}
