//
//  ControlWidgetStyle.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI

public enum ControlWidgetStyle: String, Sendable, CaseIterable, Codable {
    case circle     // 圆形
    case rectangle  // 长方形
    case square     // 正方形
    
    // 在 app 内时候，该组件中的图片的大小
    public var imageSizeInApp: CGSize {
        // 【【控制中心】组件详情显示的图标，需要调整大一点，目前有点小。】 https://www.tapd.cn/tapd_fe/66656887/bug/detail/1166656887001001690
        let length1: CGFloat = 66.0
        return CGSize(width: length1 * 0.6, height: length1 * 0.6) // ≈40
        /*
        switch self {
        case .circle:
            return CGSize(width: 36, height: 36)
        case .rectangle:
            return CGSize(width: 36, height: 36)
        case .square:
            return CGSize(width: 48, height: 48)
        }
        */
    }
    
    // 在 app 内时候，该组件中的图片的大小
    public var designSizeInApp: CGSize {
        let length1: CGFloat = 66.0
        let length2: CGFloat = 145.0
        switch self {
        case .circle:
            return CGSize(width: length1, height: length1)
        case .rectangle:
            return CGSize(width: length2, height: length1)
        case .square:
            return CGSize(width: 150.0, height: 150.0)
        }
    }
    
    public var designCornerRadius: CGFloat {
        let length1: CGFloat = 60.0
        switch self {
        case .circle:
            return length1/2.0
        case .rectangle:
            return length1/3.0
        case .square:
            return length1/3.0
        }
    }
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = ControlWidgetStyle(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .circle
        }
    }
}
