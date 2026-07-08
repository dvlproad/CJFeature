//
//  BaseControlWidgetEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJAnimationKit_Swift // 需要引入 SymbolEffectType
import CQWidgetBundleCommon // 需要引入 ControlWidgetStyle


/// 组件套
struct BaseControlWidgetSetModel: ControlWidgetBaseModel, Hashable {
    var id: String
    var name: String
    var entitys: [BaseControlWidgetEntity]
}


