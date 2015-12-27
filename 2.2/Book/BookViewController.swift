//
//  BookViewController.swift
//  Book
//
//  Created by 金波 on 15/11/28.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Property -
    let identifierBookCell = "BookCell"
    let KeyBooks = "books"
    let URLString = "https://api.douban.com/v2/book/search"
    var tag = "Swift"
    var books = [Book]()
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
   
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetManager.GET(URLString, parameters: ["tag":tag,"start":0,"count":10], success: { (responseObject) -> Void in
            self.books = []
            if let dict = responseObject as? [String:NSObject],array = dict[self.KeyBooks] as? [[String:NSObject]] {
                for dict in array {
                    self.books.append(Book(dict: dict))
                }
                self.tableView.reloadData()
            }
            }) { (error) -> Void in
                print(error)
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    //MARK: - UITableView -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bookCell = tableView.dequeueReusableCellWithIdentifier(identifierBookCell, forIndexPath: indexPath) as! BookCell
        bookCell.configureWithBook(books[indexPath.row])
        return bookCell
    }
}

