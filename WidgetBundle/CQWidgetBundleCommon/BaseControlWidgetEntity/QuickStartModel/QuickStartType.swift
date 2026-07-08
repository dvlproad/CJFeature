//
//  QuickStartWebModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation

public enum QuickStartType: String, Codable, CaseIterable, Sendable {
    case none       // 无操作
    case app        // 打开应用
    case shortcuts  // 打开快捷指令
    case web        // 打开网页
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = QuickStartType(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .none
        }
    }
}
