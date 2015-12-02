//
//  MainTabBar.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {

    // 发布按钮
    lazy var composeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlihted"), forState: .Selected)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Selected)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        self.addSubview(btn)
        return btn
    }()
    
    
    // 重新绘制tabbar
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var index = 0
        let btnCount = 5
        let w = self.bounds.size.width / CGFloat(btnCount)
        let h = self.bounds.size.height
        let frame = CGRectMake(0, 0, w, h)
        for v in subviews {
            if v is UIControl && !(v is UIButton){
                v.frame = CGRectOffset(frame, w * CGFloat(index), 0)
                index++
                if index == 2 {
                    index++
                }
            }
        }
        
        composeBtn.frame = CGRectOffset(frame, w * 2, 0)
    }

}
