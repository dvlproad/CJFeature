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
    static let kind = "com.widgetBundleDemo.toggle"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in
            let widgetInfo: BaseControlWidgetEntity = item.entity.widgetInfo
            ControlWidgetToggle(
                isOn: widgetInfo.quickStartEnable == true ? false : widgetInfo.isOn, // 快捷启动使用funWidget效果只亮一瞬
                action: BaseControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.toggle.rawValue
                ),
                label: {
                    // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                    BaseControlWidgetViewInDesktop(entity: item.entity.widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                    /*
                    ZStack {
                        Label("Running", systemImage: "hourglass")
                        
                        let appIntent = TestAppIntent(widgetId: item.entity.widgetInfo.widgetId)
                        Button(intent: appIntent) {
                            Color.red
                        }
                        .buttonStyle(.borderless)
                    }.onTapGesture {
                        debugPrint("helloworld.....")
                    }
                    */
                }
            )
            .tint(widgetInfo.tintColor) // 桌面的tint必须在此设置
        }.displayName("控制组件")
            .description("自定义你的控制组件")
            .promptsForUserConfiguration()
    }
}

import WidgetKit
import AppIntents

//  AppIntentControlValueProvider（包含 Value 和 Configuration）
@available(iOS 18.0, *)
extension BaseControlWidget {
    struct BaseToggleControlValueProvider: AppIntentControlValueProvider {
        typealias Value = BaseControlWidgetModel
        typealias Configuration = BaseControlConfigurationIntent
        
        func previewValue(configuration: BaseControlWidget.BaseControlConfigurationIntent) -> BaseControlWidget.BaseControlWidgetModel {
            return item(configuration: configuration)
        }
        
        func currentValue(configuration: BaseControlWidget.BaseControlConfigurationIntent) async throws -> BaseControlWidget.BaseControlWidgetModel {
            return item(configuration: configuration)
        }
        
        
        private func item(configuration: BaseControlWidget.BaseControlConfigurationIntent) -> BaseControlWidget.BaseControlWidgetModel {
            .init(
                entity: configuration.entity
                ?? BaseControlWidgetAppEntity.defaultEntity()
            )
        }
    }
    
    struct BaseControlWidgetModel {
        
        let entity: BaseControlWidgetAppEntity
    }

    struct BaseControlConfigurationIntent: ControlConfigurationIntent {
        static var title: LocalizedStringResource = .init(
            "widgets.controls.ControlWidgetDemoConfiguration.toggle.title",
            defaultValue: "当前组件"
        )

        static var openAppWhenRun: Bool = true

        @Parameter(
            title: .init(
                "widgets.controls.ControlWidgetDemoConfiguration.toggle.data",
                defaultValue: "当前组件")
        )
        var entity: BaseControlWidgetAppEntity?
        init() {

        }

        @MainActor
        func perform() async throws -> some IntentResult {
            return .result(value: entity)
        }
    }
}
