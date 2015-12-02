//
//  NetworkTool.swift
//  YBo
//
//  Created by Heisenbean on 15/7/10.
//  Copyright (c) 2015年 Heisenbean. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NetworkTool {
    
    /// 网络请求
//    class func requestJSON(method: Alamofire.Method, URLString: String, parameters: [String: AnyObject]? = nil,_ completion:(JSON:AnyObject?)->()){
//        Alamofire.request(method,URLString, parameters:parameters).responseJSON() { (_, _, JSON, error)in
//            if JSON == nil || error != nil{ // 如果JSON为空或者网络有错误
//                dispatch_after(3, dispatch_get_main_queue(), { () -> Void in
//                    SVProgressHUD.showWithStatus("网络繁忙,请扫后再试~")
//                })
//                println("ERROR,JSON:\(JSON),error:\(error)")
//                completion(JSON: nil)
//                return
//            }
//            completion(JSON: JSON)
//
//    }
    
//    var alamofireManager: Manager {
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        config.timeoutIntervalForRequest = 20    // 秒
//        return Manager(configuration: config)
//    }
    
    static func requestJSON(method: Alamofire.Method, URLString: String, params: [String: AnyObject]? = nil, _ completion: (JSON: AnyObject?) -> ()) {
        
//        if urlString.hasPrefix("https") {
//            Alamofire.request(method, urlString, parameters: params, encoding: ParameterEncoding.JSON, headers: ["Authorization":""])
//        } else {
        
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "api.weibo.com/": .PinCertificates(
//                certificates: ServerTrustPolicy.certificatesInBundle(),
//                validateCertificateChain: true,
//                validateHost: true
//            ),
//            "insecure.expired-apis.com": .DisableEvaluation,
//            "api.weibo.com/": .PerformDefaultEvaluation(validateHost: true)
//        ]
//        
//        let manager = Manager(
//            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//        )
        
        Alamofire.request(method, URLString, parameters: params).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (response) -> Void in
            switch response.result {
            case .Success:
                print("Success----------\(response.result.value)")  
                completion(JSON: response.result.value)
            case .Failure(let error):
                print("error----------\(error)")
                dispatch_after(3, dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.showWithStatus("网络繁忙，请稍后再试")
                })
            }
        }
//        }
    }
    
}
