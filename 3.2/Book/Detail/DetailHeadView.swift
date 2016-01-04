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
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewRatingContent: UIView!
    @IBOutlet weak var labelRatingNum: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    
    override func awakeFromNib() {
        imageViewIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showImage"))
    }
    
    func showImage() {
        
    }
    
    static func showInTableView(tableView: UITableView,book:Book) -> DetailHeadView {
        let headView = NSBundle.mainBundle().loadNibNamed("DetailHeadView", owner: nil, options: nil)[0] as! DetailHeadView
        headView.configureWith(tableView, book: book)
        return headView
    }
    
    func configureWith(tableView: UITableView,book: Book) {
        self.tableView = tableView
        self.book = book
        imageViewIcon.sd_setImageWithURL(NSURL(string: book.images["large"] ?? ""))
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
        frame.size.height = viewContainer.frame.size.height
        tableView.tableHeaderView = self
    }
    
    //评论
    @IBAction func comment(sender: AnyObject) {
    }
    
    //收藏
    @IBAction func collect(sender: AnyObject) {
    }
}
