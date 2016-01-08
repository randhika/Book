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
    var tag = "文学" //搜索关键字
    var page = 0 //搜索页码
    var books = [Book]()

    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!//放置 searchBar 的 view
   
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addMJHeaderAndFooter()
        tableView.headerBeginRefresh()
        
        // iOS 8 自动行高估算
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //设置 searchBar
        let searchController = storyboard?.instantiateViewControllerWithIdentifier("BookSearchController") as! BookSearchController
        searchController.bookController = self
        searchView.addSubview(searchController.searchController.searchBar)
    }

    //MARK: - UITableView -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bookCell = tableView.dequeueReusableCellWithIdentifier(identifierBookCell, forIndexPath: indexPath) as! BookCell
        let URLStrings = books.map { (book) -> String in
            return book.images["large"] ?? ""
        }
        bookCell.configureWithBook(books[indexPath.row],URLStrings: URLStrings)
        return bookCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let book = books[indexPath.row]
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailViewController.book = book
        detailViewController.URLStrings = books.map { (book) -> String in
            return book.images["large"] ?? ""
        }
        detailViewController.index = indexPath.row
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        
        tableView.headerAddMJRefresh { () -> Void in
            self.tableView.footerResetNoMoreData()
            
            NetManager.getBooks(self.tag, page: 0, resultClosure: { (result, books) -> Void in
                self.tableView.headerEndRefresh()
                if result {
                    self.page = 1
                    self.books = books
                    self.tableView.reloadData()
                } else {
                    self.view.makeToast("请求数据失败")
                }
            })
        }
    
        
        tableView.footerAddMJRefresh { () -> Void in
            
            NetManager.getBooks(self.tag, page: self.page, resultClosure: { (result, books) -> Void in
                
                if result {
                    var indexPaths = [NSIndexPath]()
                    let count = self.books.count
                    for (i,book) in books.enumerate() {
                        self.books.append(book)
                        indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                    }
                    
                    if indexPaths.isEmpty {
                        self.tableView.footerEndRefreshNoMoreData()
                    } else {
                        self.page++
                        self.tableView.footerEndRefresh()
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    }
                } else {
                    self.tableView.footerEndRefresh()
                    self.view.makeToast("请求数据失败")
                }
            })
            
        }
    }
}

