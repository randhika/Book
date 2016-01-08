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
    var page = 0
    var reviews = [Review]()
    var URLStrings = [String]()
    var index = 0
    
    //MARK: - IBOutlet -
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        if book != nil {
            DetailHeadView.showInVC(self)
            labelTitle.text = book.title
        } else {
            tableView.footerEndRefreshNoMoreData()
        }
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func showImage(gesture:UIGestureRecognizer) {
        PhotoBrowser.showFromImageView(gesture.view as! UIImageView,URLStrings: self.URLStrings,index:index)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.footerAddMJRefresh { () -> Void in
            NetManager.getReviewsWithBookId(self.book.id, page: self.page, resultClosure: { (result, reviews) -> Void in
                if result {
                    let count = self.reviews.count
                    var indexPaths = [NSIndexPath]()
                    for (i,review) in reviews.enumerate() {
                        self.reviews.append(review)
                        indexPaths.append(NSIndexPath(forRow: count+i, inSection: 0))
                    }
                    if indexPaths.isEmpty {
                        self.tableView.footerEndRefreshNoMoreData()
                    } else {
                        self.page++
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
                        self.tableView.footerEndRefresh()
                    }
                } else {
                    self.view.makeToast("网络异常，请上拉重试")
                    self.tableView.footerEndRefresh()
                }
            })
        }
        
        tableView.footerBeginRefresh()
    }
    
    //MARK: - UITableView -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell") as! ReviewCell
        cell.configureWithReview(reviews[indexPath.row])
        return cell
    }
    
    //返回
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition(nil) { (context) -> Void in
            PhotoBrowser.reloadForScreenRotate()
        }
    }
    
}
