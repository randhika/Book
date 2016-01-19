//
//  User.swift
//  DouBan
//
//  Created by Admin on 15/2/27.
//  Copyright (c) 2015年 jinbo. All rights reserved.
//

import UIKit


class User: NSObject,NSCoding {
    
    let KeyExpires_time = "expires_in"
    let KeyAccess_token = "access_token"
    let KeyDouban_user_name = "douban_user_name"
    let KeyRefresh_token = "refresh_token"
    let KeyDouban_user_id = "douban_user_id"
    
    //单例
    static let sharedUser = NSKeyedUnarchiver.unarchiveObjectWithFile(documentPath + "/user") as? User ?? User()
    
    //User登陆信息
    //过期时间
    var expires_time = 0.0
    var access_token = ""
    var douban_user_name = ""
    var refresh_token = ""
    var douban_user_id = ""
    
    var isLogin:Bool {
        if !access_token.isEmpty && expires_time > NSDate().timeIntervalSince1970 {
            return true
        } else {
            return false
        }
    }
    
    func loginWithDict(dict:[String:NSObject]) {
        if let expires_in = dict[KeyExpires_time] as? Double {
            expires_time = NSDate().timeIntervalSince1970 + expires_in
        }
        access_token = dict[KeyAccess_token] as? String ?? ""
        douban_user_name = dict[KeyDouban_user_name] as? String ?? ""
        refresh_token = dict[KeyRefresh_token] as? String ?? ""
        douban_user_id = dict[KeyDouban_user_id] as? String ?? ""
        NSKeyedArchiver.archiveRootObject(self, toFile: documentPath + "/user")
    }
    
    func logout() {
        expires_time = 0.0
        access_token = ""
        douban_user_name = ""
        refresh_token = ""
        douban_user_id = ""
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(expires_time, forKey: KeyExpires_time)
        aCoder.encodeObject(access_token, forKey: KeyAccess_token)
        aCoder.encodeObject(douban_user_name, forKey: KeyDouban_user_name)
        aCoder.encodeObject(refresh_token, forKey: KeyRefresh_token)
        aCoder.encodeObject(douban_user_id, forKey: KeyDouban_user_id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        expires_time = aDecoder.decodeObjectForKey(KeyExpires_time) as? Double ?? 0.0
        access_token = aDecoder.decodeObjectForKey(KeyAccess_token) as? String ?? ""
        douban_user_name = aDecoder.decodeObjectForKey(KeyDouban_user_name) as? String ?? ""
        refresh_token = aDecoder.decodeObjectForKey(KeyRefresh_token) as? String ?? ""
        douban_user_id = aDecoder.decodeObjectForKey(KeyDouban_user_id) as? String ?? ""
    }

    override init() {
        super.init()
    }
}
