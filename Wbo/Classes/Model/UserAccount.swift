//
//  UserAccount.swift
//  Wbo
//
//  Created by integrated on 10/21/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import UIKit
import Alamofire
import EVReflection

class UserAccount: NSObject, NSCoding {
    
    // 账号信息
    let access_token: String
    
    // access_token的生命周期
    let expires_in: NSTimeInterval
    
    // access_token的过期时间
    let expires_Date: NSDate
    
    /// 用户id
    let uid: String
    
    /// 用户名
    var name: String = ""
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String = ""
    
    init(dict: [String: AnyObject]) {
        access_token = dict["access_token"] as! String
        expires_in = dict["expires_in"] as! NSTimeInterval
        expires_Date = NSDate(timeIntervalSinceNow: expires_in)
        uid = dict["uid"] as! String
    }
    
    
    // 儲存路徑
    static let accountPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last)!.stringByAppendingString("/account.plist")
    
    
    // 獲取Token
    class func getAccessToken(params: [String: AnyObject], completation: (account: UserAccount?) -> ()) {
        
        let requestStr = "https://api.weibo.com/oauth2/access_token"
        NetworkTool.requestJSON(.POST, URLString: requestStr, params: params) { (JSON) -> () in
            guard let json = JSON as? [String: AnyObject]
            else {
                completation(account: nil)
                return
            }
            
            // 生成一个UserAccount对象并存到本地
            let obj = UserAccount(dict: json)
            
            // 讀取用戶詳細資料
            obj.loadUserInfo(completation)
            
            print(UserAccount.accountPath)
            
            // 存檔到本地
            NSKeyedArchiver.archiveRootObject(obj, toFile: UserAccount.accountPath)
            completation(account: obj)
        }
    }
    
    // 加载用户信息
    func loadUserInfo(completation: (account: UserAccount?)->()) {
        let strUrl = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token":access_token,"uid":uid]
        
        NetworkTool.requestJSON(.GET, URLString: strUrl, params: params) { [unowned self] (JSON) -> () in
            guard let json = JSON as? [String: AnyObject]
            else {
                completation(account: nil)
                return
            }
            
            self.name = json["name"] as? String ?? ""
            self.avatar_large = json["avatar_large"] as? String ?? ""
            
            // 存檔到本地
            NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
            completation(account: self)
            
        }
        
    }
    
    
    // 從本地獲取token
    class func loadAccountToken() -> UserAccount? {
        
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount
        else {
             return nil
        }
        
        // 比較時間
        if account.expires_Date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return account
        } else {
            return nil
        }
        
    }
    
    
    // MARK:归解档
    
    /// 归档
    internal func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    
    internal required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as! String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as! NSDate
        expires_in = aDecoder.decodeDoubleForKey("expires_in") as NSTimeInterval
        uid = aDecoder.decodeObjectForKey("uid") as! String
        name = aDecoder.decodeObjectForKey("name") as! String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as! String
    }

    
    // debug description
    override var description: String {
        return "access_token: \(self.access_token)"
    }
}
