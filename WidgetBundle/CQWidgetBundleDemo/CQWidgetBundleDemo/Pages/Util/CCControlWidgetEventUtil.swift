//
//  CCControlWidgetEventUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/25.
//

class CCControlWidgetEventUtil {
    // 控制中心对应组件浏览:单个
    static func browse(outId: String? = nil) {
        
    }
    // 控制中心对应组件浏览:多个（eg:套图)
    static func browseGroupId(_ groupId: String, selectedEntitys: [BaseControlWidgetEntity]) {
        if selectedEntitys.count == 0 { // 如果为0，则代表是远程的zip还是解压出来就尝试上报了
            return
        }
        
        browse(outId: groupId)
        
        for selectedEntity in selectedEntitys {
            browse(outId: selectedEntity.widgetId)
        }
    }
    
    // 控制中心对应组件保存:单个
    static func save(outId: String? = nil) {
        
    }
    // 控制中心对应组件保存:多个（eg:套图)
    static func saveGroupId(_ groupId: String, selectedEntitys: [BaseControlWidgetEntity]) {
        save(outId: groupId)
        
        for selectedEntity in selectedEntitys {
            save(outId: selectedEntity.widgetId)
        }
    }
    
    // 图标素材点击统计
    static func clickSymbolIconId(outId: String) {
        
    }
    
    // 文字素材点击统计
    static func clickTextId(outId: String) {
        
    }
    
    //TODO: qian
    // 控制中心对应组件锁屏/控制中心点击
    static func clickWidgetId(_ outId: String) {
        
    }
}
