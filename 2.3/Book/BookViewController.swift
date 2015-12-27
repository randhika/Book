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
    var tag = "Swift" //搜索关键字
    var page = 0 //搜索页码
    var pageSize = 10
    var books = [Book]()
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
   
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMJHeaderAndFooter()
        tableView.headerBeginRefresh()
        
        // iOS 8 自动行高估算
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
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        
        tableView.headerAddMJRefresh { () -> Void in
            self.tableView.footerResetNoMoreData()
            NetManager.GET(self.URLString, parameters: ["tag":self.tag,"start":0,"count":self.pageSize],showHUD: false, success: { (responseObject) -> Void in
                    self.books = []
                    if let dict = responseObject as? [String:NSObject],array = dict[self.KeyBooks] as? [[String:NSObject]] {
                        for dict in array {
                            self.books.append(Book(dict: dict))
                        }
                        self.tableView.reloadData()
                        self.page = 1
                    }
                    self.tableView.headerEndRefresh()
                }) { (error) -> Void in
                    print(error)
                    self.tableView.headerEndRefresh()
                }
        }
        
        tableView.footerAddMJRefresh { () -> Void in
            NetManager.GET(self.URLString, parameters: ["tag":self.tag,"start":self.page * self.pageSize,"count":self.pageSize],showHUD: false, success: { (responseObject) -> Void in
                    var indexPaths = [NSIndexPath]()
                    if let dict = responseObject as? [String:NSObject],array = dict[self.KeyBooks] as? [[String:NSObject]] {
                        let count = self.books.count
                        for (i,dict) in array.enumerate() {
                            self.books.append(Book(dict: dict))
                            indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                        }
                    }
                    
                    if indexPaths.isEmpty {
                        self.tableView.footerEndRefreshNoMoreData()
                    } else {
                        self.page++
                        self.tableView.footerEndRefresh()
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    }
                
                }) { (error) -> Void in
                    print(error)
                    self.tableView.footerEndRefresh()
                }
        }
    }
}

