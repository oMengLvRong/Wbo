//
//  StatusHelper.swift
//  YBo
//
//  Created by integrated on 11/17/15.
//  Copyright © 2015 Heisenbean. All rights reserved.
//

import UIKit

class StatusHelper: NSObject {
    
    private static var instance: StatusHelper = StatusHelper()
    class var shareInstance: StatusHelper {return instance}
    
    func stringWithTimelineDate(dateString: String?) -> String {
        guard dateString != nil, let date = creatAtDate.dateFromString(dateString!) else { return ""}
        
        let now = NSDate()
        let delta = now.timeIntervalSince1970 - date.timeIntervalSince1970
        if delta < -60 * 10 { // 本地时间有问题
            return formatterFullDate.stringFromDate(date)
        } else if (delta < 60 * 10) {
            return "刚刚"
        } else if (delta < 60 * 60) { // 1小时内
            return "\(Int(delta/60))" + "分钟前"
        } else if (date.isToday) {
            return "\(Int(delta/3600))" + "小时前"
        } else if (date.isYesterday) {
            return formatterYesterday.stringFromDate(date)
        } else if (date.year == now.year) {
            return formatterSameYear.stringFromDate(date)
        } else {
            return formatterFullDate.stringFromDate(date)
        }
    }
    
    func stringWithSource(sourceString: String?) -> String {
        guard sourceString != nil, let source = sourceString as? NSString else { return "" }
        
        /// 截串 NSString
        var range = NSRange()
        range.location = source.rangeOfString(">").location + 1
        range.length = source.rangeOfString("</").location - range.location
        return String(source.substringWithRange(range))
    }
    
    // MARK: - 部分表达式
    lazy var formatterYesterday: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "昨天 HH:mm"
        formatter.locale = NSLocale.currentLocale()
        return formatter
        }()
    
    lazy var formatterSameYear: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M-d"
        formatter.locale = NSLocale.currentLocale()
        return formatter
        }()
    
    lazy var formatterFullDate: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yy-M-dd"
        formatter.locale = NSLocale.currentLocale()
        return formatter
        }()
    
    lazy var creatAtDate: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter
        }()
    
    lazy var regexEmoticon: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\[[^ \\[\\]]+?\\]", options: [.AllowCommentsAndWhitespace])
        }()
    
    lazy var regexAt: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "@[-_a-zA-Z0-9\u{4E00}-\u{9FA5}]+", options: [.AllowCommentsAndWhitespace])
        }()
    
    lazy var regexTopic: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "#[^@#]+?#", options: [.AllowCommentsAndWhitespace])
        }()
}
