//
//  BaseQuickStartControlWidget.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/5.
//

import AppIntents
import SwiftUI
import WidgetKit
import CQWidgetBundleCommon

@available(iOS 18.0, *)
struct BaseQuickStartControlWidget: ControlWidget {
    static let kind = "com.widgetBundleDemo.quickStart"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseQuickStartControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in
            let widgetInfo: BaseControlWidgetEntity = item.entity.widgetInfo
            let openUrl = widgetInfo.getStateModel().getOpenUrl()
            let needOpenApp = openUrl != nil
            ControlWidgetToggle(
                isOn: false,    // 使用 ControlWidgetToggle 并设置isOn为false, 以及打开时候的tint，使得点击的时候可显示瞬间的颜色tintColor
//            ControlWidgetButton(
                action: QuickStartControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                ),
//                action: needOpenApp ? QuickStartControlWidgetToggleAction(
//                    widgetId: widgetInfo.widgetId,
//                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
//                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
//                ) : QuickStartControlWidgetToggleAction(
//                    widgetId: widgetInfo.widgetId,
//                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
//                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
//                ),
//                action: {
//                    if needOpenApp {
//                        QuickStartControlWidgetToggleAction(
//                            widgetId: widgetInfo.widgetId,
//                            widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
//                            desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
//                        )
//                    } else {
//                        QuickStartControlWidgetToggleAction2(
//                            widgetId: widgetInfo.widgetId,
//                            widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
//                            desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
//                        )
//                    }
//                },
                label: {
                    // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                    BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                }
            )
            .tint(widgetInfo.tintColor) // 桌面的tint必须在此设置
            
        }.displayName("快捷启动")
            .description("快速运行你的快捷启动")
            .promptsForUserConfiguration()
    }
}

import WidgetKit
import AppIntents

@available(iOS 18.0, *)
extension BaseQuickStartControlWidget {
    struct BaseToggleControlValueProvider: AppIntentControlValueProvider {
        typealias Value = BaseControlWidgetModel
        typealias Configuration = BaseQuickStartControlConfigurationIntent
        
        func previewValue(configuration: BaseQuickStartControlWidget.BaseQuickStartControlConfigurationIntent) -> BaseQuickStartControlWidget.BaseControlWidgetModel {
            return item(configuration: configuration)
        }
        
        func currentValue(configuration: BaseQuickStartControlWidget.BaseQuickStartControlConfigurationIntent) async throws -> BaseQuickStartControlWidget.BaseControlWidgetModel {
            return item(configuration: configuration)
        }
        
        
        private func item(configuration: BaseQuickStartControlWidget.BaseQuickStartControlConfigurationIntent) -> BaseQuickStartControlWidget.BaseControlWidgetModel {
            .init(
                entity: configuration.entity
                ?? QuickStartControlWidgetAppEntity.defaultEntity()
            )
        }
    }
    
    struct BaseControlWidgetModel {
        
        let entity: QuickStartControlWidgetAppEntity
    }

    struct BaseQuickStartControlConfigurationIntent: ControlConfigurationIntent {
        static var title: LocalizedStringResource = .init(
            "widgets.controls.ControlWidgetDemoConfiguration.quickStart.title",
            defaultValue: "当前组件"
        )

        static var openAppWhenRun: Bool = true

        @Parameter(
            title: .init(
                "widgets.controls.ControlWidgetDemoConfiguration.quickStart.data",
                defaultValue: "当前组件")
        )
        var entity: QuickStartControlWidgetAppEntity?
        init() {

        }

        @MainActor
        func perform() async throws -> some IntentResult {
            return .result(value: entity)
        }
    }
}
