//
//  ImageService.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/25.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    static func cropImage(original: UIImage, target: UIImageView) -> UIImage{
        let imSize = original.size
        let imViewSize = target.bounds.size
        if(imSize.width <= imViewSize.width || imSize.height <= imViewSize.height) {
            return original
        }
        var scale = imViewSize.width / imSize.width
        if(imSize.height * scale < imViewSize.height) {
            scale = imViewSize.height / imSize.height
        }
        let croppedImSize = CGSize(width: imViewSize.width / scale, height: imViewSize.height / scale)
        let croppedImRect = CGRect(origin: CGPoint(x: (imSize.width - croppedImSize.width) / 2.0, y: (imSize.height - croppedImSize.height) / 2.0), size: croppedImSize)
        let croppedImRef = (original.cgImage?.cropping(to: croppedImRect))!
        let croppedIm = UIImage(cgImage: croppedImRef)
        let r = UIGraphicsImageRenderer(size: imViewSize)
        let scaledIm = r.image { _ in
            croppedIm.draw(in: CGRect(origin: .zero, size: imViewSize))
        }
        return scaledIm
    }
    
    static func cropNewsImages(newsList: [News]) -> [UIImage]{
        var croppedImages = [UIImage]()
      //  let target = UIImageView(frame: CGRect(x:0, y:0, width: 130, height: 130))
        for news in newsList {
            if(news.image == "unavailable") {
                croppedImages.append(#imageLiteral(resourceName: "default-guardian"))
            } else {
                let url = URL(string: news.image)
                let data = try? Data(contentsOf: url!)
                let originImage = UIImage(data: data!)!
                croppedImages.append(originImage)
            }
        }
        return croppedImages
    }
}
