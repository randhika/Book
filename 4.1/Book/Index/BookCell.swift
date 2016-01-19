//
//  BookCell.swift
//  Book
//
//  Created by 金波 on 15/12/26.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit
import SDWebImage

class BookCell: UITableViewCell {

    var URLStrings = [String]()
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewRatingContainer: UIView!
    @IBOutlet weak var labelDetail: UILabel!
    
    override func awakeFromNib() {
        imageViewIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "clickImageView"))
    }
    
    func clickImageView() {
        if let tableView = self.superview?.superview as? UITableView {
            let indexPath = tableView.indexPathForCell(self)
            PhotoBrowser.showFromImageView(imageViewIcon, URLStrings:URLStrings, index: indexPath?.row ?? 0)
        }
    }
    
    func configureWithBook(book:Book,URLStrings:[String]) {
        self.URLStrings = URLStrings
        imageViewIcon.setResizeImageWith(book.image, width: imageViewIcon.frame.size.width)
        if let rating = book.rating {
            RatingView.showInView(viewRatingContainer, value: rating.average)
        } else {
            RatingView.showNoRating(viewRatingContainer)
        }
        labelTitle.text = book.title
        
        var detail = ""
        
        for str in book.author {
            detail += (str + "/")
        }
        labelDetail.text = detail + book.publisher + "/" + book.pubdate
    }
}
