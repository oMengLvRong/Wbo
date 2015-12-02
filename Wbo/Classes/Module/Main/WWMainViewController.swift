//
//  ViewController.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

class WWMainViewController: UITabBarController {
    
    @IBOutlet var mainTabBar: MainTabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置渲染颜色
        self.tabBar.tintColor = UIColor.orangeColor()
        
        mainTabBar.composeBtn.addTarget(self, action: "compose", forControlEvents: UIControlEvents.TouchUpInside)
        
        addChildsVc()
        
    }
    
    // 发布按钮点击事件
    func compose() {
//        print("compose")
        
        presentViewController(UIStoryboard.initialViewController("Prepare"), animated: true, completion: nil)
        
    }
    
    // 添加其他控制器
    private func addChildsVc() {
        addChildVc("Home", title: "首页", imgName: "tabbar_home")
        addChildVc("Message", title: "消息", imgName: "tabbar_message_center")
        addChildVc("Discover", title: "发现", imgName: "tabbar_discover")
        addChildVc("Profile", title: "我", imgName: "tabbar_profile")
    }
    
    private func addChildVc(sbName: String, title: String, imgName: String) {

        let nav = UIStoryboard.initialViewController(sbName) as! UINavigationController
        nav.topViewController?.title = title
        nav.tabBarItem.image = UIImage(named: imgName)
        nav.tabBarItem.selectedImage = UIImage(named: imgName + "_highlighted")
        addChildViewController(nav)
    }

}

