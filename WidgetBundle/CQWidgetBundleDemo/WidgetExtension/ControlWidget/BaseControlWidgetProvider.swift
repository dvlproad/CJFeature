//
//  BaseControlWidgetProvider.swift
//  WidgetExtensionExtension
//
//  Created by qian on 2025/1/10.
//
//  AppIntentControlValueProvider（包含 Value 和 Configuration）

import WidgetKit
import AppIntents

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
                ?? BaseControlWidgetEntity.nilEntity()
            )
        }
    }
    
    struct BaseControlWidgetModel {
        
        let entity: BaseControlWidgetEntity
    }

    struct BaseControlConfigurationIntent: ControlConfigurationIntent {
        static var title: LocalizedStringResource = .init(
            "widgets.controls.ControlWidgetDemoConfiguration.toggle.title",
            defaultValue: "控制选项"
        )

        static var openAppWhenRun: Bool = true

        @Parameter(
            title: .init(
                "widgets.controls.ControlWidgetDemoConfiguration.toggle.data",
                defaultValue: "控制选项")
        )
        var entity: BaseControlWidgetEntity?
        init() {

        }

        @MainActor
        func perform() async throws -> some IntentResult {
            return .result(value: entity)
        }
    }
}
