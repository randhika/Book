//
//  PhoneBrowserController.swift
//  Book
//
//  Created by 金波 on 16/1/4.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class PhotoBrowser: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    let KeyPhotoBrowserCell = "PhotoBrowserCell"
    
    weak var imageView:UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBackground: UIView!
    var URLStrings = [String]()
    
    //frame 相对于 keyWindow 的位置
    static func showFromImageView(imageView:UIImageView,URLStrings:[String],index:Int) -> PhotoBrowser {
        let browser = NSBundle.mainBundle().loadNibNamed("PhotoBrowser", owner: nil, options: nil)[0] as! PhotoBrowser
        browser.imageView = imageView
        browser.configureBrowser(URLStrings)
        browser.animateImage(index)
        return browser
    }
    
    static func reloadForScreenRotate() {
        for view in MainWindow.subviews {
            if let view = view as? PhotoBrowser {
                view.reloadForScreenRotate()
            }
        }
    }
    
    func reloadForScreenRotate() {
        collectionView.reloadData()
        collectionView.contentOffset.x = collectionView.contentOffset.x * ScreenWidth / ScreenHeight
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return URLStrings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(KeyPhotoBrowserCell, forIndexPath: indexPath) as! PhotoBrowserCell
        cell.imageView.setImageWith(URLStrings[indexPath.row])
        return cell
    }
    
    func configureBrowser(URLStrings:[String]) {
        self.URLStrings = URLStrings
        collectionView.registerNib(UINib(nibName: KeyPhotoBrowserCell, bundle: nil), forCellWithReuseIdentifier: KeyPhotoBrowserCell)
        MainWindow.addSubview(self)
        self.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(MainWindow)
        }
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closeBrowser"))
    }
    
    func closeBrowser() {
        self.removeFromSuperview()
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell  = cell as? PhotoBrowserCell {
            cell.scrollView.zoomScale = 1
        }
    }
    
    func animateImage(index:Int) {
        var startFrame = self.imageView.superview!.convertRect(self.imageView.frame, toView:MainWindow )
        var endFrame = UIScreen.mainScreen().bounds
        self.imageView.hidden = true
        if let image = self.imageView.image {
            
            let ratio = image.size.width / image.size.height
            
            if ratio < (startFrame.width / startFrame.height) {
                let midX = CGRectGetMidX(startFrame);
                startFrame.size.width = startFrame.height * ratio;
                startFrame.origin.x = midX - startFrame.size.width / 2;
            } else {
                let midY = CGRectGetMidY(startFrame);
                startFrame.size.height = startFrame.width / ratio;
                startFrame.origin.y = midY - startFrame.size.height / 2;
            }
            
            if ratio < ScreenRatio {
                endFrame.size.width = ScreenHeight * ratio;
                endFrame.origin.x = ScreenMidX - endFrame.size.width / 2;
            } else {
                endFrame.size.height = ScreenWidth / ratio;
                endFrame.origin.y = ScreenMidY - endFrame.size.height / 2;
            }
        }
        
        let tempImageView = UIImageView(frame: startFrame)
        tempImageView.image = imageView.image
        tempImageView.contentMode = .ScaleAspectFit
        MainWindow.addSubview(tempImageView)
        viewBackground.alpha = 0
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                tempImageView.frame = endFrame
                self.viewBackground.alpha = 1
            }) { (result) -> Void in
                self.imageView.hidden = false
                self.collectionView.setContentOffset(CGPointMake(ScreenWidth * CGFloat(index),0), animated: false)
                self.collectionView.hidden = false;
                tempImageView.removeFromSuperview()

        }
        
        dispatch_after(5) { () -> () in
            tempImageView.removeFromSuperview()
        }
    }
    
    
}
