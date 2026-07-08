//
//  ControlWidgetCategory.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation
import CQWidgetBundleCommon // 需要引入 ControlWidgetType

public enum ControlWidgetCategory: String, Sendable, Codable {
    case unknown            // 位置组件
    case toggle_icon = "0"  // 图标组件
    case open_app = "1"     // 快捷启动应用
//    case open_shortcut      // 快捷指令
//    case audio =  "2"       // 音频
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = ControlWidgetCategory(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .unknown
        }
    }
    
    public func toControlWidgetType() -> ControlWidgetType {
        switch self {
        case .unknown:
            return .unknown
        case .toggle_icon:
            return .toggle_icon
        case .open_app:
            return .open_app
//        case .audio:
//            return .audio
        }
    }
}

