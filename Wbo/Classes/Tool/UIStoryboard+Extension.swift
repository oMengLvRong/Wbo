//
//  UIStoryboard+Extension.swift
//  YBo
//
//  Created by Heisenbean on 15/7/7.
//  Copyright (c) 2015年 Heisenbean. All rights reserved.
//

import UIKit
extension UIStoryboard{
    
    /// 返回一个Storyboard的控制器
    class func initialViewController(name:String) -> UIViewController{
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
}
