//
//  User.swift
//  WBo
//
//  Created by Heisenbean on 15/7/10.
//  Copyright (c) 2015年 Heisenbean. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /// 用户UID
    var id: NSInteger = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?{
        didSet{
            iconURL = NSURL(string: profile_image_url!)
        }
    }
    /// 用户头像
    var iconURL:NSURL?
    
    /// 认证类型 1-没有认证 0-认证用户 2,3,5:-企业认证 220-草根明星（达人）
    var verified_type: NSInteger = -1
    
    /// 1～6 一共6级会员
    var mbrank: Int = 0
    
    var verifiedTypeImage: UIImage? {
        switch verified_type {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    
    var vipRankIamge:UIImage? {
        if mbrank > 0 && mbrank < 7{
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        return nil
    }

    private static let properties = ["id","name","profile_image_url","verified_type","mbrank"]
    
    init(dict: [String:AnyObject]) {
        super.init()
        for key in User.properties{
            if dict[key] != nil{
                setValue(dict[key], forKeyPath: key)
            }
        }
    }
}
