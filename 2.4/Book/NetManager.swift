//
//  NetManager.swift
//  Book
//
//  Created by 金波 on 15/12/25.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import Toast

struct NetManager {
    
    static let URLStringBooks = "https://api.douban.com/v2/book/search"
    static let KeyBooks = "books"
    static let netError = "网络异常，请检查网络"
    static let pageSize = 10

    static func getBooks(tag:String, page:Int,resultClosure:(Bool,[Book]!) -> Void) {
        NetManager.GET(URLStringBooks, parameters: ["tag":tag,"start":page * pageSize,"count":pageSize],showHUD: false, success: { (responseObject) -> Void in
                var books = [Book]()
                if let dict = responseObject as? [String:NSObject],array = dict[self.KeyBooks] as? [[String:NSObject]] {
                    for dict in array {
                        books.append(Book(dict: dict))
                    }
                }
                resultClosure(true,books)
            }) { (error) -> Void in
                resultClosure(false,nil)
        }

    }
    
    static func getBookTitles(tag:String, page:Int,resultClosure:([String]) -> Void) {
        NetManager.GET(URLStringBooks, parameters: ["tag":tag,"start":0,"count":10,"fields":"title"],showHUD: false, success: { (responseObject) -> Void in
                var searchTitles = [String]()
                if let dict = responseObject as? [String:NSObject],array = dict[self.KeyBooks] as? [[String:NSObject]] {
                    for dict in array {
                        if let title = dict["title"] as? String {
                            searchTitles.append(title)
                        }
                    }
                }
                resultClosure(searchTitles)
            }) { (error) -> Void in
            }
    }

    static func GET(URLString:String, parameters:[String:NSObject]?, showHUD:Bool = true, success:((NSObject?) -> Void)?, failure:((NSError) -> Void)?) {
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.timeoutInterval = 10
        
        let mainWindow = UIApplication.sharedApplication().delegate!.window!
        
        if showHUD {
            MBProgressHUD.showHUDAddedTo(mainWindow, animated: true)
        }
        
        manager.GET(URLString, parameters: parameters, success: { (task, responseObject) -> Void in
            if showHUD {
                MBProgressHUD.hideAllHUDsForView(mainWindow, animated: true)
            }
            success?(responseObject as? NSObject)
            }) { (task, error) -> Void in
                if showHUD {
                    MBProgressHUD.hideAllHUDsForView(mainWindow, animated: true)
                    mainWindow?.makeToast(netError)
                }
                failure?(error)
        }
    
    }
    
    static func POST(URLString:String, parameters:[String:NSObject]?, showHUD:Bool = true, success:((NSObject?) -> Void)?, failure:((NSError) -> Void)?) {
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.timeoutInterval = 10
        
        let mainWindow = UIApplication.sharedApplication().delegate!.window!
        
        if showHUD {
            MBProgressHUD.showHUDAddedTo(mainWindow, animated: true)
        }
        
        manager.POST(URLString, parameters: parameters, success: { (task, responseObject) -> Void in
            if showHUD {
                MBProgressHUD.hideAllHUDsForView(mainWindow, animated: true)
            }
            success?(responseObject as? NSObject)
            }) { (task, error) -> Void in
                if showHUD {
                    MBProgressHUD.hideAllHUDsForView(mainWindow, animated: true)
                    mainWindow?.makeToast(netError)
                }
                failure?(error)
        }
    }
}
