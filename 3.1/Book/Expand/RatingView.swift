//
//  BookRatingView.swift
//  Rating Demo
//
//  Created by 金波 on 15/12/28.
//  Copyright © 2015年 On The Pursuit. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    var max = 5.0 //最大评分
    var starHeight = 22.0 //星星高度
    var starSpace = 4.0 //星星间距
    var emptyImageViews = [UIImageView]()
    var fullImageViews = [UIImageView]()
    var value = 0.0 {
        didSet {
            if value > max {
                value = max
            } else if value < 0 {
                value = 0
            }
            
            for (i,imageView) in fullImageViews.enumerate() {
                let i = Double(i)
                if value >= i + 1 {
                    imageView.layer.mask = nil
                    imageView.hidden = false
                } else if value < i + 1 && value > i {
                    let maskLayer = CALayer()
                    maskLayer.frame = CGRect(x: 0, y: 0, width: (value - i) * Double(starHeight), height: Double(starHeight))
                    maskLayer.backgroundColor = UIColor.blackColor().CGColor
                    imageView.layer.mask = maskLayer
                    imageView.hidden = false
                } else {
                    imageView.layer.mask = nil
                    imageView.hidden = true
                }
            }
        }
    }

    init(starHeight:Double,max:Double) {
        self.starHeight = starHeight
        self.max = max
        self.starSpace = starHeight * 0.15
        let frame = CGRect(x: 0, y: 0, width: starHeight * max + starSpace * (max - 1), height: starHeight)
        super.init(frame: frame)
        for i in 0...4 {
            let i = Double(i)
            let emptyImageView = UIImageView(image: UIImage(named: "star_empty"))
            let fullImageView = UIImageView(image: UIImage(named: "star_full"))
            let frame = CGRect(x: starHeight * i + starSpace * i, y: 0, width: starHeight, height: starHeight)
            emptyImageView.frame = frame
            fullImageView.frame = frame
            emptyImageViews.append(emptyImageView)
            fullImageViews.append(fullImageView)
            addSubview(emptyImageView)
            addSubview(fullImageView)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    static func showInView(view:UIView,value:Double,max:Double = 5) {
        for subview in view.subviews {
            if let subview = subview as? RatingView {
                subview.value = value
                return
            }
        }
        
        let ratingView = RatingView(starHeight: Double(view.frame.size.height), max: max)
        
        view.addSubview(ratingView)
        ratingView.value = value
    }
}
