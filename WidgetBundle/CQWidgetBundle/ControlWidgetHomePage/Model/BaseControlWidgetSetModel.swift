//
//  BaseControlWidgetSetModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import CQWidgetBundleCommon // 需要引入 ControlWidgetStyle

/// 组件套
public struct BaseControlWidgetSetModel: ControlWidgetBaseModel, Hashable {
    public var id: String
    public var name: String
    public var entitys: [BaseControlWidgetEntity]
    
    public init(id: String, name: String, entitys: [BaseControlWidgetEntity]) {
        self.id = id
        self.name = name
        self.entitys = entitys
    }
}


