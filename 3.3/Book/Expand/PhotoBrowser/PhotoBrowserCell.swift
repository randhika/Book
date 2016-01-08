//
//  PhotoBrowserCell.swift
//  Book
//
//  Created by 金波 on 16/1/6.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class PhotoBrowserCell: UICollectionViewCell,UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
