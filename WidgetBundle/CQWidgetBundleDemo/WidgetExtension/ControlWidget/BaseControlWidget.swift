//
//  BaseControlWidget.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//
//  ControlWidget（包含 AppIntentControlConfiguration 的 provider 和 ControlWidgetToggle 的 action）

import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 18.0, *)
struct BaseControlWidget: ControlWidget {
    static let kind = "com.cqWidgetBundleDemo.toggle"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in

            
            ControlWidgetToggle(
                isOn: item.entity.isOn,
                action: BaseControlWidgetToggleAction(widgetId: item.entity.id, widgetSaveId: item.entity.saveId ?? "unknow_saveId")
            ) {
                // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                BaseControlWidgetView(entity: item.entity)
            }
            .tint(item.entity.tintColor)
            
        }.displayName("基础控制组件")
            .description("选择自定义组件2")
            .promptsForUserConfiguration()
    }
}
