//
//  ControlToggleWidget.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import AppIntents
import SwiftUI
import WidgetKit
import SwingAnimation

@available(iOS 18.0, *)
struct ControlToggleWidget: ControlWidget {
    static let kind = "com.controlDemo.toggle"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: ControlToggleWidget.kind,
            provider: ControlWidgetToggleProvider()
        ) { item in

            // 开启状态的图标颜色
            let themeColor = Color.orange

            ControlWidgetToggle(
                isOn: ControlToggleWidgerValueManage.shared.value,
                action: ControlToggleWidgetIntent()
            ) {
                // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                // 使用的文字和图标可以通过 item.entity 去关联一个数据模型，从数据模型取
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
//                    .clockHandRotationEffect(period: .custom(2), in: TimeZone.current, anchor: .center)
                    .clockHandRotationEffect(period: .custom(30), in: .current, anchor: .center)
//                Label {
////                    Text("标题")
//                    Text(item.entity.title ?? "标题2")
//                    Text("副标题2")
//                } icon: {
//                    ///  此处图标使用实际业务对应的SF图标
//                    // 系统SF图标
//                    //                    Image(systemName: "figure.walk")
//                    // 自定义SF图标
////                    let rotate = ControlToggleWidgerValueManage.shared.value
////                    Image("icon_control_katong_6")
//////                        .rotationEffect(Angle.degrees(rotate ? 360 : 0))
//////                        .animation(rotate ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default, value: rotate)
////                        .clockHandRotationEffect(period: .custom(1), in: TimeZone.current, anchor: .top)
//                    
//                    Image(systemName: "arrow.clockwise")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 50, height: 50)
//                        .clockHandRotationEffect(period: .custom(1), in: TimeZone.current, anchor: .top)
//                }

            }
            .tint(themeColor)  // 设定开启状态的图标颜色
        }.displayName("控制组件2")
            .description("选择自定义组件2")
            .promptsForUserConfiguration()
    }
}

@available(iOS 18.0, *)
extension ControlToggleWidget {

    struct ControlToggleItem {
        let entity: ControlWidgetToggleEntity
    }

    struct ControlWidgetToggleProvider: AppIntentControlValueProvider {

        func currentValue(configuration: ControlToggleWidgetConfiguration)
            async throws -> ControlToggleItem
        {
            return item(configuration: configuration)
        }

        func previewValue(
            configuration: ControlToggleWidget.ControlToggleWidgetConfiguration
        ) -> ControlToggleWidget.ControlToggleItem {
            return item(configuration: configuration)
        }

        private func item(configuration: ControlToggleWidgetConfiguration)
            -> ControlToggleItem
        {
            .init(
                entity: configuration.entity
                    ?? ControlWidgetToggleEntity(
                        id: UUID().uuidString, uuid: "11111"))
        }

    }

    struct ControlToggleWidgetConfiguration: ControlConfigurationIntent {
        init() {

        }
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
        var entity: ControlWidgetToggleEntity?

        @MainActor
        func perform() async throws -> some IntentResult {
            return .result(value: entity)
        }
    }
}

// 自定义控制中心选择列表
@available(iOS 18.0, *)
struct ControlWidgetToggleEntity: AppEntity {
    static var defaultQuery: ControlWidgetToggleEntityQuery = ControlWidgetToggleEntityQuery()
    
    typealias DefaultQuery = ControlWidgetToggleEntityQuery
    

    static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "选择控制组件3")

//    static let defaultQuery = ControlWidgetToggleEntityQuery()

    var id: String
    var uuid: String
    var title: String?

    var displayRepresentation: DisplayRepresentation {
        let title = self.title ?? "控制组件"
        let subTitle = "还未选择控制组件"
        let iconName = "web_camera"
        return DisplayRepresentation(
            title: "\(title)", subtitle: "\(subTitle)",
            image: .init(named: iconName, isTemplate: false))
    }

    init(id: String, uuid: String, title: String? = nil) {
        self.id = id
        self.uuid = uuid
        self.title = title

    }

}

@available(iOS 18.0, *)
struct ControlWidgetToggleEntityQuery: EntityQuery, EntityStringQuery {

    /// 实际测试结果是需要同步实现配置数据的加载，否则选择配置后，数据无法回调到控制组件
    let dataItems = [Int](1...20).map { idx in
        return ControlWidgetToggleEntity(
            id: UUID().uuidString, uuid: "customId_\(idx)", title: "样式\(idx)")
    }

    func entities(for identifiers: [String]) async throws
        -> [ControlWidgetToggleEntity]
    {
        return dataItems.filter({ entity in
            return identifiers.contains(entity.id)
        })
    }

    func entities(matching string: String) async throws -> IntentItemCollection<
        ControlWidgetToggleEntity
    > {
        
        let reslutItems = dataItems.filter({ item in
            return (item.title ?? "").contains(string)
        })
        return .init(items: reslutItems)
    }

    func suggestedEntities() async throws -> IntentItemCollection<
        ControlWidgetToggleEntity
    > {
        return .init(items: dataItems)
    }

    /// 官方及现有网上教程是用一个函数来异步获取保存的配置信息，但实际是选择后,数据不会同步
    private func getItems() async throws -> [ControlWidgetToggleEntity] {
        return dataItems
    }
}
