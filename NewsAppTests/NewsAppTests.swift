//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by 潘一帆 on 2020/4/11.
//  Copyright © 2020 Yifan. All rights reserved.
//

import XCTest
@testable import NewsApp

class NewsAppTests: XCTestCase {

    func test() {
        let url = URL(string: "https://media.guim.co.uk/48a4ef7ca9e78e96dab6468c960395d6fbe61f50/0_247_4110_2466/master/4110.jpg")
        let data = try? Data(contentsOf: url!)
        let bigImage = UIImage(data: data!)!
        let target = UIImageView(frame: CGRect(x:0, y:0, width: 130, height: 130))
        let croppedImage = ImageService.cropImage(original: bigImage, target: target)
        print("original image size: \(bigImage.size)")
        print("cropped image size: \(croppedImage.size)")
    }
    

}
