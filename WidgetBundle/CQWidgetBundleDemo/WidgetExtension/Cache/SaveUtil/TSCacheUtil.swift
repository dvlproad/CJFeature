//
//  TSCacheUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation

public struct TSCacheUtil {
    // 确保需要的那些 Target 都添加了 App Group
    static public let ApplicationGroupName = "group.cn.widgetisland.theme"
    
    static public func valueForKey(_ key: String) -> Data? {
        if let userDefaults = UserDefaults(suiteName: ApplicationGroupName) {
            if let jsonData = userDefaults.value(forKey: key) {
                return jsonData as? Data
            }
            
            return nil
        }
        return nil
    }
    
    static public func stringForKey(_ key: String) -> String? {
        if let userDefaults = UserDefaults(suiteName: ApplicationGroupName) {
            if let jsonData = userDefaults.value(forKey: key) {
                return jsonData as? String
            }
            
            return nil
        }
        return nil
    }
    
    static public func set(_ value: Any?, forKey: String) {
        if let userDefaults = UserDefaults(suiteName: ApplicationGroupName) {
            userDefaults.set(value, forKey: forKey)
            userDefaults.synchronize()
        }
    }
}
