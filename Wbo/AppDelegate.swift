//
//  AppDelegate.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

var shareUserAccount = UserAccount.loadAccountToken()

let SwitchRootViewControllerNoti = "SwitchRootViewControllerNoti"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        setupAppearance()
        
        // TODO: - 判断版本号加载不同的sb
        
        return true
    }

    // 设置主题
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }

}

