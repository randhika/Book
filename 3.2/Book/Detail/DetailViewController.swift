//
//  DetailViewController.swift
//  Book
//
//  Created by 金波 on 16/1/3.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Property
    var book: Book!
    
    //MARK: - IBOutlet -
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        if book != nil {
            DetailHeadView.showInTableView(tableView, book: book)
            labelTitle.text = book.title
        } else {
            tableView.footerEndRefreshNoMoreData()
        }
    }
    
    //MARK: - UITableView -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //返回
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
