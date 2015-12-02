//
//  OauthViewController.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import SVProgressHUD

class OauthViewController: UIViewController {

//    let Client_Id = "2682533555"
//    let Redirect_Uri = "http://www.baidu.com"
//    let Grant_type = "authorization_code"
//    let Client_secret = "252ce4b4bc18598dd5f6f31aefa3dcec"
    
    let Client_Id = "3650985595"
    let Redirect_Uri = "http://www.iaround.com"
    let Grant_type = "authorization_code"
    let Client_secret = "5eb4f4b933974967dd423e4d173c5760"
    
    @IBAction func close(sender: UIBarButtonItem) {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadOauthView()
    }
    
    func loadOauthView() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=" + Client_Id + "&redirect_uri=" + Redirect_Uri
        let url = NSURL(string: urlString)
        self.webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    private func getAccessToken(code: String) {
        
        let params = ["client_id":Client_Id,
            "client_secret":Client_secret,
            "grant_type":Grant_type,
            "code":code,
            "redirect_uri":Redirect_Uri,]
        
        UserAccount.getAccessToken(params) { (account) -> () in
            shareUserAccount = account
            
            print(shareUserAccount)
            
            NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewControllerNoti, object: "Welcome")
            SVProgressHUD.dismiss()
            self.dismissViewControllerAnimated(true, completion: nil)   // 退出modal出的视图时一定要dismiss掉
        }
        
    }


}

extension OauthViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let str = request.URL!.absoluteString //url中绝对字符串
                
        if str.hasPrefix("https://api.weibo.com/") {
            return true
        }
        
        if str.hasPrefix(Redirect_Uri) {
            let queStr = request.URL!.query!
            let codeStr = "code="
            if queStr.hasPrefix(codeStr) { //授权成功
                let code = queStr.componentsSeparatedByString(codeStr)[1]
                getAccessToken(code)
            } else { //授权失败
                SVProgressHUD.dismiss()
                dismissViewControllerAnimated(true, completion: nil)
                NSLog("授权失败")
            }
        }
        
        return false
    }
 
}
