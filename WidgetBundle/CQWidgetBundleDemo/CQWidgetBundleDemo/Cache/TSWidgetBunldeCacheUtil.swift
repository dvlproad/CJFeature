//
//  TSWidgetBundleCacheUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation
import WidgetKit

struct TSWidgetBundleCacheUtil {
    
}

// 控制中心单个组件
extension TSWidgetBundleCacheUtil {
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
            debugPrint("反序列化错误:  \(error)")
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
            debugPrint("序列化错误:  \(error)")
            //return false
        }
    }
}

// 控制中心组件数组
extension TSWidgetBundleCacheUtil {
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
            debugPrint("反序列化错误:  \(error)")
            return []
        }
    }
    
    
    // 在桌面根据保存的id获取组件
    static func findControlWidgetEntity(_ saveId: String, in entitys: [BaseControlWidgetEntity]) -> BaseControlWidgetEntity? {
        // let entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        // let entitys = TSWidgetBundleCacheUtil.getControlWidgets()
        for (index, item) in entitys.enumerated() {
            if item.saveId == saveId {
                return item
            }
        }
        return nil
    }
    
    // 在 App 内或外 更新组件
    static func updateControlWidgetEntity(_ entity: BaseControlWidgetEntity, shouldRefreshDesktop: Bool) {
        if let saveId = entity.saveId {  // 如果有保存id，说明是更新
            for (index, item) in TSWidgetEntityManager.shared.controlWidgetEntitys.enumerated() {
                if item.saveId == saveId {
                    TSWidgetEntityManager.shared.controlWidgetEntitys[index] = entity
                    break
                }
            }
        }
        let entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        self.updateControlWidgetEntitys(entitys, influenceScope: shouldRefreshDesktop ? .dataAndWidgetUI : .onlyData)
    }
    
    // 在 App 内添加组件
    static func addControlWidgetEntity(_ entity: BaseControlWidgetEntity) {
        TSWidgetEntityManager.shared.controlWidgetEntitys.append(entity)
        
        let entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        self.updateControlWidgetEntitys(entitys, influenceScope: .onlyData)
    }
    
    
    static func replaceEntity(_ newWidgetModel: BaseControlWidgetEntity, in entitys: inout [BaseControlWidgetEntity], influenceScope: WidgetDataInfluenceScope) {
        guard let saveId = newWidgetModel.saveId else { return }   // 如果有保存id，才去更新
        /*
        for (index, item) in entitys.enumerated() {
            if item.saveId == saveId {
                entitys[index] = newWidgetModel
                break
            }
        }
        */
        
        if let index = entitys.firstIndex(where: { $0.saveId == saveId }) {
            entitys[index] = newWidgetModel
        }
        
        updateControlWidgetEntitys(entitys, influenceScope: influenceScope)
    }
    
    static private func updateControlWidgetEntitys(_ entitys: [BaseControlWidgetEntity], influenceScope: WidgetDataInfluenceScope) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(entitys)
            TSCacheUtil.set(jsonData, forKey: controlWidgetsKey)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                debugPrint("保存的信息为:\(jsonString)")  // 输出JSON字符串
            }
            //return true
        } catch {
            debugPrint("序列化错误:  \(error)")
            //return false
        }
        
        if influenceScope == .dataAndWidgetUI {
            if #available(iOS 18.0, *) {
                ControlCenter.shared.reloadControls(
                    ofKind: "com.cqWidgetBundleDemo.toggle" //BaseControlWidget.kind
                )
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// 组件数据的更新影响范围
enum WidgetDataInfluenceScope {
    case onlyData               // 只更新数据
    case dataAndWidgetUI        // 更新数据并且刷新组件
}

