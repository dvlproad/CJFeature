//
//  TSAppCacheUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/18.
//

import Foundation


struct TSQuickStartAppsUtil {
    static let quickStartAppsKey = "kQuickStartApps"
    
    static func getQuickStartApps() -> [QuickStartAppModel] {
        let jsonData = TSCacheUtil.valueForKey(quickStartAppsKey)
        if jsonData == nil {
            return []
        }
        
        let decoder = JSONDecoder()
        do {
            let models = try decoder.decode([QuickStartAppModel].self, from: jsonData!)
            return models
        } catch {
            debugPrint("反序列化错误: \(error)")
            return []
        }
    }
    
    static private func updateQuickStartApps(_ entitys: [QuickStartAppModel]) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(entitys)
            TSCacheUtil.set(jsonData, forKey: quickStartAppsKey)
            
            //if let jsonString = String(data: jsonData, encoding: .utf8) {
            //    debugPrint("保存的信息为:\(jsonString)")  // 输出JSON字符串
            //}
            //return true
        } catch {
            debugPrint("序列化错误: \(error)")
            //return false
        }
    }
}


extension TSQuickStartAppsUtil {
    static func addQuickStartApp(_ model: QuickStartAppModel, inPrefix: Bool = false) {
        var oldModels = getQuickStartApps()
        if inPrefix {
            oldModels.insert(model, at: 0)
        } else {
            oldModels.append(model)
        }
        
        self.updateQuickStartApps(oldModels)
    }
    
    
    // 根据 id 更新值
    static func replaceQuickStartApp(_ newModel: QuickStartAppModel, in models: inout [QuickStartAppModel]) {
        guard let saveId = newModel.saveId else { return }
        /*
        for (index, item) in models.enumerated() {
            if item.saveId == saveId {
                models[index] = newModel
                break
            }
        }
        */
        
        if let index = models.firstIndex(where: { $0.saveId == saveId }) {
            models[index] = newModel
        }
        
        updateQuickStartApps(models)
    }
    
    
}
