//
//  NSDate+Extensions.swift
//  Wbo
//
//  Created by integrated on 11/25/15.
//  Copyright © 2015 integrated. All rights reserved.
//

import Foundation

extension NSDate {
    
    var day: NSInteger {
        get {
            return NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: self)
        }
    }
    
    var year: NSInteger {
        get {
            return NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: self)
        }
    }
    
    var isToday: Bool {
        get {
//            if abs(self.timeIntervalSinceNow) >= 60 * 60 * 24 {
//                return false
//            } else {
//                return NSDate().day == self.day
//            }
            
            return NSCalendar.currentCalendar().isDateInToday(self)
        }
    }
    
    var isYesterday: Bool {
        get {
            let added = self.dateByAddingTimeInterval(1 * 60 * 60 * 24)
            return added.isToday
        }
    }

}