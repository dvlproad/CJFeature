//
//  WidgetClickModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation

// 组件的点击信息（功德组件需要使用，必要时候可能重置）
public struct WidgetClickModel: ControlWidgetBaseModel, Hashable {
    public var count: Int
    var lastClickDate: Date
    
    public init() {
        self.count = 0
        self.lastClickDate = Date()
    }
}
