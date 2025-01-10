//
//  CJLogUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2024/1/10.
//

import Foundation


class CJLogUtil {
    static var lastLogDate: Date? = nil
    
    static func log(_ message: String = "") {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateString = formatter.string(from: date)
        
        // 计算两个时间的时间差，是多少秒多少毫秒
        let timeInterval = date.timeIntervalSince(lastLogDate ?? date)
        // timeInterval 保留三位小数
        let timeIntervalString = String(format: "%.3f", timeInterval)
        lastLogDate = date
        
        debugPrint("===qian===\(dateString)(\(timeIntervalString)) \(message)")
    }
}
