//
//  LoginViewController.swift
//  Book
//
//  Created by 金波 on 16/1/14.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UIWebViewDelegate {

    //应用的唯一标识，对应于APIKey
    let client_id = "044a3a0984e7ef550cdeae1c8eb7cdff"
    let client_secret = "eb0d6aeeede176e6"
    //用户授权完成后的回调地址，应用需要通过此回调地址获得用户的授权结果。此地址必须与在应用注册时填写的回调地址一致。
    let redirect_uri = "https://www.baidu.com"
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: NetManager.OAuthLogin.URLStringGetCode)!))
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType:UIWebViewNavigationType) -> Bool {
        if let URLString = request.URL?.absoluteString {
            print("shouldStartLoadWithRequest:" + URLString)
            if URLString.hasPrefix(redirect_uri) {
                if let range = URLString.rangeOfString("?code=") {
                    let code = URLString.substringFromIndex(range.endIndex)
                    NetManager.OAuthLogin.loginWithCode(code, resultClosure: { (result) -> Void in
                        if result {
                          self.view.window!.makeToast("登陆成功")
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                } else if let _ = URLString.rangeOfString("?error=") {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                return false
            }
        }
        return true
    }
    
    //isOAuthing
    var isOAuthing = false
    func webViewDidFinishLoad(webView: UIWebView) {
        if let URLString = webView.request?.URL?.absoluteString {
            print("didFinishLoad:\(URLString)")
        }
    }
}
