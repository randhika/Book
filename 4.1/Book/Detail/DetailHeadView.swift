//
//  DetailHeadView.swift
//  Book
//
//  Created by 金波 on 16/1/1.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

//详情页 headView
class DetailHeadView: UIView {
    //MARK: - Property
    var tableView: UITableView!
    var book: Book!
    var vc: DetailViewController!
    //MARK: - IBOutlet
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewRatingContent: UIView!
    @IBOutlet weak var labelRatingNum: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelSummary: UILabel!

    static func showInVC(vc:DetailViewController) -> DetailHeadView {
        let headView = NSBundle.mainBundle().loadNibNamed("DetailHeadView", owner: nil, options: nil)[0] as! DetailHeadView
        headView.configureWith(vc.tableView, book: vc.book)
        headView.vc = vc
        headView.imageViewIcon.addGestureRecognizer(UITapGestureRecognizer(target: vc, action: "showImage:"))
        return headView
    }
    
    func configureWith(tableView: UITableView,book: Book) {
        self.tableView = tableView
        self.book = book
        imageViewIcon.setImageWith(book.image)
        labelTitle.text = book.title
        if let rating = book.rating {
            RatingView.showInView(viewRatingContent, value: rating.average)
            labelRatingNum.text = "\(rating.numRaters)人评分"
        } else {
            RatingView.showNoRating(viewRatingContent)
        }
        
        var desc = ""
        for str in book.author {
            desc += (str + "/")
        }
        
        labelPublisher.text = desc + book.publisher + "/" + book.pubdate
        labelSummary.text = book.summary
        
        self.tableView.tableHeaderView = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = viewContainer.frame.size.height
        tableView.tableHeaderView = self
    }

    //评论
    @IBAction func comment(sender: AnyObject) {
        if User.sharedUser.isLogin {
            print("login")
        } else {
            vc.navigationController?.pushViewController(UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController"), animated: true)
        }
        
    }
    
    //收藏
    @IBAction func collect(sender: AnyObject) {
    }
}
