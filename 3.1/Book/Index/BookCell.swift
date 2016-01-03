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

    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewRatingContainer: UIView!
    @IBOutlet weak var labelDetail: UILabel!
    
    func configureWithBook(book:Book) {
        
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
