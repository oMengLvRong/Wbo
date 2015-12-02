//
//  Status.swift
//  YBo
//
//  Created by Heisenbean on 15/7/10.
//  Copyright (c) 2015年 Heisenbean. All rights reserved.
//  微博首页数据模型

import UIKit
import Alamofire
import SDWebImage
private let WB_HOME_LINE_URL = "https://api.weibo.com/2/statuses/friends_timeline.json"
class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 微博ID
    var id: Int = 0
    
    /// 微博正文
    var text : String?
    
    /// 微博来源
    var source: String?
    
    /// 配图数组
    var pic_urls:[[String:String]]?{
        didSet{
            imageUrls = [NSURL]()   //实例化配图数组
            largeUrls = [NSURL]()
            
            for dict in pic_urls!{
                if let urlStr = dict["thumbnail_pic"]{  // 取出普通(缩略图)的图片地址
                    // 把缩略图路径中的关键字替换为大图的
                    let largeStr = (urlStr as NSString).stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    // 将两种图片地址添加到数组中
                    largeUrls?.append(NSURL(string: largeStr)!)
                    imageUrls?.append(NSURL(string: urlStr)!)
                }
            }
        }
    }
    
    /// 缩略图的url数组
    private var imageUrls: [NSURL]?
    
    /// 大图的url数组
    private var largeUrls: [NSURL]?
    
    var user: User?
    
    /// 属性数组
    private static let properties = ["created_at","id","text","source","pic_urls"]
    
    /// 转发微博数据
    var retweeted_status: Status?
    
    /// 判断是否是转发微博图片(缩略图)
    var pictureURLs:[NSURL]?{
        return retweeted_status != nil ? retweeted_status?.imageUrls : imageUrls
    }
    
    /// 判断是转发还是原创微博的大图
    var largePicURLs:[NSURL]?{
        return retweeted_status != nil ? retweeted_status?.largeUrls : largeUrls
    }
    
    
    /* 一个带闭包回调的加载微博数据的类方法
    since_id(后加)   若指定此参数，则返回ID比since_id大的微博，默认是0,就是用来加载新数据用的
    max_id           若指定此参数，则返回ID小于或等于max_id的微博，默认为0,加载旧数据
    */
    class func loadStatus(since_id since_id: Int = 0,max_id: Int = 0,completion:(statuses:[Status]?) ->()){
        
        var params = ["access_token":shareUserAccount!.access_token]
        if since_id > 0{
            params["since_id"] = "\(since_id)"
        }else if max_id > 0 {
            params["max_id"] = "\(max_id - 1)"
        }
        
        NetworkTool.requestJSON(.GET, URLString: WB_HOME_LINE_URL, params: params){ (JSON) -> () in
            if JSON != nil{
                do {
                    _ = try NSJSONSerialization.dataWithJSONObject(JSON!, options: NSJSONWritingOptions())
                } catch {
                    completion(statuses: nil)
                    return
                }
                
                if let array = (JSON as! NSDictionary)["statuses"] as? [[String:AnyObject]]{
                    let result = self.statuses(array)
                    self.cacheStatusImage(result, completion: completion)
                    return
                }
            }
            completion(statuses: nil)
        }
    }
    
    /// 缓存微博图片
    class func cacheStatusImage(statuses:[Status]?,completion:(statuses:[Status]?) ->()){
        
        if statuses == nil{
            completion(statuses: nil)
            return
        }
        
        let group = dispatch_group_create()
        for s in statuses as [Status]!{
            if s.pictureURLs?.count == 0 {
                continue    // 没有图片,继续循环
            }
            
            // 继续遍历装图片url的数组
            for url in s.pictureURLs!{
                // 进入群组之后的block为异步任务,能收到群组的监听
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(), progress: nil, completed: { (_, _, _, _, _) in
                    // 离开群组,一定要放在block的最后一句代码,表示异步执行完成
                    dispatch_group_leave(group)
                })
            }
        }
        
        
        /*
        这里用到 dispatch_group_enter(group)   和   dispatch_group_leave(group),以及群组通知
        是为了保证彻底缓存完图片后在执行某一件事情
        */
        // 群组通知
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            //            println("缓存完####-->\(NSHomeDirectory())")
            completion(statuses: statuses)
        }
        
    }
    
    // 字典数组转换模型数组
    private class func statuses(array:[[String:AnyObject]])->[Status]?{
        if array.count == 0{
            return nil
        }
        var arrayM = [Status]()
        for newDict in array{
            arrayM.append(Status(dict: newDict))
        }
        return arrayM
    }
    
    /**
    字典转模型
    
    :param: dict 字典
    
    :returns: init函数不用返回
    */
    init(dict:[String:AnyObject]){
        super.init()
        for key in Status.properties{
            if dict[key] != nil{
                // 在swift中如果使用kvc需要先`super.init()`,确保对象被实例化
                setValue(dict[key], forKeyPath: key)
            }
        }
        //  用户其实又是一个数据模型,所以单独拿出来做特殊处理
        if dict["user"] != nil{
            user = User(dict: dict["user"] as! [String:AnyObject])
        }
        
        // 转发微博数据,也是一个模型数据
        if dict["retweeted_status"] != nil{
            retweeted_status = Status(dict: dict["retweeted_status"] as! [String:AnyObject])
        }
        
    }
    
}
