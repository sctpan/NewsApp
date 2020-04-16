//
//  ShareService.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/15.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation
import UIKit

class ShareService {
    static func shareWithTwitter(url: String) {
        let tweetUrl = url
        let tweetText = "Check out this Article!"
        let hashtag = "CSCI_571_NewsApp"
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(hashtag)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
