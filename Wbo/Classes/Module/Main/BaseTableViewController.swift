//
//  BaseTableViewController.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit


// 这是一个遵循登陆协议的tableviewController,作用是为了先检查是否有登陆
class BaseTableViewController: UITableViewController {
    
    var login: Bool {
        return shareUserAccount != nil
    }
//
//    var login = false
    
    var loginView: LoginView?
    
    override func loadView() {
        if login { // 已登陆
            super.loadView()
            return
        } else {
            loginView = NSBundle.mainBundle().loadNibNamed("LoginView", owner: nil, options: nil).last as? LoginView
            loginView?.delegate = self
            self.view = loginView
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnClicked")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnClicked")
        
        print("loginView-----BaseTableViewController ")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }

}

extension BaseTableViewController : LoginViewDelegate {
    
    func loginBtnClicked() {
        presentViewController(UIStoryboard.initialViewController("Oauth"), animated: true, completion: nil)
    }
    
    func registerBtnClicked() {
        
    }
}
