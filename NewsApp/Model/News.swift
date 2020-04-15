//
//  News.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation

class News: Encodable, Decodable {
    var id = ""
    var title = ""
    var section = ""
    var date = ""
    var shareUrl = ""
    var timeDiff = ""
    var description = ""
    var image = ""
}
