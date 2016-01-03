//
//  BookExtensions.swift
//  Book
//
//  Created by 金波 on 15/12/27.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImage {
    
    //调整 UIImage size
    func resizeToSize(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
}

extension UIImageView {
    
    //SDWebImage 下载图片并调整 size
    func setResizeImageWith(URLString:String, width:CGFloat) {
        let URL = NSURL(string: URLString)
        let key = SDWebImageManager.sharedManager().cacheKeyForURL(URL) ?? ""
        
        if var cacheImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(key) { // 取本地缓存图片并设置合适的 size
            if cacheImage.size.width > width {
                let size = CGSizeMake(width, cacheImage.size.height * (width / cacheImage.size.width))
                cacheImage = cacheImage.resizeToSize(size)
            }
            self.image = cacheImage
        } else { // 下载网络图片并设置合适的 size
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(URL, options: .AllowInvalidSSLCertificates, progress: nil, completed: { (var image, data, error, result) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if image != nil && image.size.width > width {
                        let size = CGSizeMake(width, image.size.height * (width / image.size.width))
                        
                        image = image.resizeToSize(size)
                    }
                    self.image = image
                })
            })
        }
    }
}