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
            //debugPrint("解码后的数据:  \(controlWidgetEntity.name),  \(controlWidgetEntity.title)")
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

// 桌面组件类型
enum DesktopWidgetControlType: String {
    case all            // 所有的
    case toggle         // 控制组件
    case quickStart     // 快捷启动
}

// 控制中心组件数组
extension TSWidgetBundleCacheUtil {
    static let controlWidgetsKey = "kControlWidgets"
    
    /// 我的组件页面的控制组件数据（有可能需要归类排序）
    static func getControlWidgetsForMyWidgets() -> [BaseControlWidgetEntity] {
        var entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        if entitys.count == 0 {
            entitys = getCacheControlWidgets(.all)
            TSWidgetEntityManager.shared.controlWidgetEntitys = entitys
        }
        
        // 进行倒序
        let reversedEntities = entitys.reversed()
        // 排序操作
        let sortedEntities = reversedEntities.sorted { (e1, e2) -> Bool in
            // 优先级: circle > rectangle > square
            if e1.widgetStyle == .circle && e2.widgetStyle != .circle {
                return true
            } else if e1.widgetStyle == .rectangle && e2.widgetStyle != .circle && e2.widgetStyle != .rectangle {
                return true
            } else if e1.widgetStyle == .square && e2.widgetStyle == .square {
                return false
            } else {
                return e1.widgetStyle.rawValue < e2.widgetStyle.rawValue
            }
        }
        return sortedEntities
    }
    
    static func getControlWidgets(_ desktopWidgetControlType: DesktopWidgetControlType) -> [BaseControlWidgetEntity] {
        var entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        if entitys.count == 0 {
            entitys = getCacheControlWidgets(desktopWidgetControlType)
            TSWidgetEntityManager.shared.controlWidgetEntitys = entitys
        }
        
        return entitys
    }
    
    static func getCacheControlWidgets(_ desktopWidgetControlType: DesktopWidgetControlType) -> [BaseControlWidgetEntity] {
        let jsonData = TSCacheUtil.valueForKey(controlWidgetsKey)
        if jsonData == nil {
            return []
        }
        
        let decoder = JSONDecoder()
        do {
            let controlWidgetEntitys = try decoder.decode([BaseControlWidgetEntity].self, from: jsonData!)
            //debugPrint("解码后的数据:  \(controlWidgetEntity.name),  \(controlWidgetEntity.title)")
            if (desktopWidgetControlType == .toggle) {
                let filteredItems = controlWidgetEntitys.filter { $0.quickStartEnable != true }
                return filteredItems
            } else if (desktopWidgetControlType == .quickStart) {
                let filteredItems = controlWidgetEntitys.filter { $0.quickStartEnable == true }
                return filteredItems
            } else {
                return controlWidgetEntitys
            }
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
    static func updateControlWidgetEntitys(_ originalUpdateEntitys: [BaseControlWidgetEntity], shouldRefreshDesktop: Bool) {
        var entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        
        for originalUpdateEntity in originalUpdateEntitys {
            if let saveId = originalUpdateEntity.saveId {  // 如果有保存id，说明是更新
                for (index, item) in entitys.enumerated() {
                    if item.saveId == saveId {
                        entitys[index] = originalUpdateEntity
                        break
                    }
                }
            }
        }
        TSWidgetEntityManager.shared.controlWidgetEntitys = entitys
        
        self.updateControlWidgetEntitys(entitys, influenceScope: shouldRefreshDesktop ? .dataAndReloadControls : .onlyData)
    }
    
    static func updateControlWidgetEntity(_ entity: BaseControlWidgetEntity, shouldRefreshDesktop: Bool) {
        updateControlWidgetEntitys([entity], shouldRefreshDesktop: shouldRefreshDesktop)
    }
    
    // 在 App 内添加组件
    static func addControlWidgetEntitys(_ originalAddEntitys: [BaseControlWidgetEntity]) {
        var entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        
        for originalAddEntity in originalAddEntitys {
            // 设置我的组件标题
            let filteredItems = entitys.filter { $0.widgetId == originalAddEntity.widgetId }
            /*
            let pureName = entity.name
            var hasAddSameCount: Int = 0    // 相同控件已经添加的个数
            if let lastAddItem = filteredItems.last {
                let titleArray = lastAddItem.name.components(separatedBy: " #")
                if titleArray.count > 1, titleArray[0] == pureName {
                    let num = Int(titleArray[1])
                    hasAddSameCount = num ?? 0
                }
            } else {
                hasAddSameCount = 0
            }
            */
            let hasAddSameCount: Int = filteredItems.last?.samePosition ?? 0    // 相同控件已经添加的个数
            var addEntity = originalAddEntity
            addEntity.id = UUID().uuidString    // 保存的时候更新id，以修复在桌面选择组件时候不会选中相同id
            addEntity.saveId = UUID().uuidString
            addEntity.samePosition = hasAddSameCount +  1
            
            entitys.append(addEntity)
        }
        TSWidgetEntityManager.shared.controlWidgetEntitys = entitys
        
        self.updateControlWidgetEntitys(entitys, influenceScope: .onlyData)
    }
    
    
    static func addControlWidgetEntity(_ entity: BaseControlWidgetEntity) {
        addControlWidgetEntitys([entity])
    }
    
    // 在 App 内删除组件
    static func deleteControlWidgetEntityWithSaveId(_ targetSaveId: String) {
        var entitys = TSWidgetEntityManager.shared.controlWidgetEntitys
        entitys = entitys.filter { $0.saveId != targetSaveId }
        TSWidgetEntityManager.shared.controlWidgetEntitys = entitys
        
        self.updateControlWidgetEntitys(entitys, influenceScope: .onlyData)
    }
    
    
    /// 在所有组件中更新组件信息
    /// - Parameters:
    ///   - newWidgetModel: 新的组件模型
    ///   - entitys: 所有的组件（不是分类组件）
    ///   - influenceScope: 更新的影响范围
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
                //debugPrint("保存的信息为:\(jsonString)")  // 输出JSON字符串
            }
            //return true
        } catch {
            debugPrint("序列化错误:  \(error)")
            //return false
        }
        
        // 不管是 app内的详情页操作后返回 还是 app外桌面上的操作，都应该通知 我的组件页里的控制中心组件视图更新
        NotificationCenter.default.post(name: Notification.Name("kNoti_Update_myControlWidgets"), object: nil)
        if influenceScope == .dataAndReloadControls {
            if #available(iOS 18.0, *) {
                ControlCenter.shared.reloadControls(
                    ofKind: BaseControlWidget.kind
                )
                //ControlCenter.shared.reloadControls(ofKind: BaseQuickStartControlWidget.kind)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// 组件数据的更新影响范围
enum WidgetDataInfluenceScope {
    case onlyData               // 只更新数据
    case dataAndReloadControls  // 更新数据并且刷新桌面组件
}

