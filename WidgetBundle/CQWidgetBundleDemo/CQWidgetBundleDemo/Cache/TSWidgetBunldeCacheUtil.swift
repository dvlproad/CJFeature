//
//  TSWidgetBunldeCacheUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation

struct TSWidgetBunldeCacheUtil {
    
}

// 控制中心单个组件
extension TSWidgetBunldeCacheUtil {
    static let controlWidgetKey = "kControlWidget"
    static func getControlWidget() -> BaseControlWidgetEntity? {
        let jsonData = TSCacheUtil.valueForKey(controlWidgetKey)
        if jsonData == nil {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let controlWidgetEntity = try decoder.decode(BaseControlWidgetEntity.self, from: jsonData!)
            debugPrint("解码后的用户:  $user.name),  $user.age)")
            return controlWidgetEntity
        } catch {
            debugPrint("反序列化错误:  $error)")
            return nil
        }
    }
    
    static func saveControlWidgetEntity(_ entity: BaseControlWidgetEntity) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(entity)
            TSCacheUtil.set(jsonData, forKey: controlWidgetKey)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                debugPrint(jsonString)  // 输出JSON字符串
            }
            //return true
        } catch {
            debugPrint("序列化错误:  $error)")
            //return false
        }
    }
}

// 控制中心组件数组
extension TSWidgetBunldeCacheUtil {
    static let controlWidgetsKey = "kControlWidgets"
    static func getControlWidgets() -> [BaseControlWidgetEntity] {
        let jsonData = TSCacheUtil.valueForKey(controlWidgetsKey)
        if jsonData == nil {
            return []
        }
        
        let decoder = JSONDecoder()
        do {
            let controlWidgetEntitys = try decoder.decode([BaseControlWidgetEntity].self, from: jsonData!)
            debugPrint("解码后的用户:  $user.name),  $user.age)")
            return controlWidgetEntitys
        } catch {
            debugPrint("反序列化错误:  $error)")
            return []
        }
    }
    
    static func addControlWidgetEntity(_ entity: BaseControlWidgetEntity) {
        let encoder = JSONEncoder()
        do {
            TSWidgetEntityManager.shared.controlWidgetEntitys.append(entity)
            let entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
            
            let jsonData = try encoder.encode(entitys)
            TSCacheUtil.set(jsonData, forKey: controlWidgetsKey)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                debugPrint(jsonString)  // 输出JSON字符串
            }
            //return true
        } catch {
            debugPrint("序列化错误:  $error)")
            //return false
        }
    }
}

