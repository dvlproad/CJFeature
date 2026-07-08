//
//  ControlWidgetType.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI

public enum ControlWidgetType: String, Sendable, Codable {
//    case toogle         // 有开关状态的图标组件
//    case quickStart     // 快捷启动
    
    case unknown            // 位置组件
    case toggle_icon        // 图标组件
    case open_app           // 快捷启动应用
    case open_shortcut      // 快捷指令
    case audio              // 音频组件
//    case woodenFish         // 木鱼
//    case dice               // 骰子
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = ControlWidgetType(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .unknown
        }
    }
}
