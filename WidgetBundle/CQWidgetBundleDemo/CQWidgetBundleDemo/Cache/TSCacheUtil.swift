//
//  TSCacheUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation

struct TSCacheUtil {
    static let ApplicationGroupName = "group.dvlproad.cqwidgetbundledemo"
    
    static func valueForKey(_ key: String) -> Data? {
        if let userDefaults = UserDefaults(suiteName: ApplicationGroupName) {
            if let jsonData = userDefaults.value(forKey: key) {
                return jsonData as? Data
            }
            
            return nil
        }
        return nil
    }
    
    static func set(_ value: Any?, forKey: String) {
        if let userDefaults = UserDefaults(suiteName: ApplicationGroupName) {
            userDefaults.set(value, forKey: forKey)
        }
    }
}
