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
import CJWidgetKit_Swift

@available(iOS 18.0, *)
struct BaseControlWidget: ControlWidget {
    static let kind = "com.cqWidgetBundleDemo.toggle"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in

//            RotatingControlWidgetToggle(isOn: item.entity.isOn)
            /*
            ControlWidgetToggle(
                isOn: item.entity.isOn,
                action: BaseControlWidgetToggleAction(widgetId: item.entity.id, widgetSaveId: item.entity.saveId ?? "unknow_saveId")
            ) {
                // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                BaseControlWidgetView(entity: item.entity)
                
//                CJWidgetGifImageView(gifName: "transformer", defaultImage: "")
//                    .frame(width: 40, height: 40)
                
//                Image(systemName: "arrow.clockwise")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 50, height: 50)
//                    .clockHandRotationEffect(period: .custom(1), in: TimeZone.current, anchor: .top)
            }
//            .tint(item.entity.tintColor)
            */
            ControlWidgetButton(action: BaseControlWidgetToggleAction(widgetId: item.entity.id, widgetSaveId: item.entity.saveId ?? "unknow_saveId")
            ) {
                // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                BaseControlWidgetView(entity: item.entity)
//                Image(systemName: "arrow.clockwise")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 50, height: 50)
//                    .clockHandRotationEffect(period: .custom(1), in: TimeZone.current, anchor: .top)
            }
            .tint(item.entity.tintColor)
            
           
            
        }.displayName("基础控制组件")
            .description("选择自定义组件2")
            .promptsForUserConfiguration()
    }
    
    @State private var rotationIndex = 0
    let iconNames = [
        "arrow.2.circlepath.circle",  // 可用的 SF Symbols 图标
        "arrow.2.circlepath.circle.fill",
        "arrow.clockwise.circle",
        "arrow.clockwise.circle.fill"
    ]
    
    private func startRotation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            rotationIndex = (rotationIndex + 1) % iconNames.count
        }
    }
}
