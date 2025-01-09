//
//  BaseControlWidgetEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import AppIntents

@available(iOS 18.0, *)
struct BaseControlWidgetEntity: AppEntity, Codable {
    var displayRepresentation: DisplayRepresentation {
        let title = self.title ?? "控制组件"
        let subTitle = "还未选择控制组件"
        let iconName = "web_camera"
        return DisplayRepresentation(
            title: "\(title)", subtitle: "\(subTitle)",
            image: .init(named: iconName, isTemplate: false))
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "选择控制组件")
    
    typealias DefaultQuery = BaseControlWidgetEntityQuery
    static var defaultQuery: BaseControlWidgetEntityQuery = BaseControlWidgetEntityQuery()
    

    var id: String
    var uuid: String
    var title: String?
    init(id: String, uuid: String, title: String? = nil) {
        self.id = id
        self.uuid = uuid
        self.title = title

    }
}



@available(iOS 18.0, *)
struct BaseControlWidgetEntityQuery: EntityQuery, EntityStringQuery {
    func suggestedEntities() async throws -> IntentItemCollection<BaseControlWidgetEntity> {
        return .init(items: dataItems)
    }
    
    func entities(for identifiers: [String]) async throws -> [BaseControlWidgetEntity] {
        return dataItems.filter({ entity in
            return identifiers.contains(entity.id)
        })
    }

    func entities(matching string: String) async throws -> IntentItemCollection<BaseControlWidgetEntity> {
        let reslutItems = dataItems.filter({ item in
            return (item.title ?? "").contains(string)
        })
        return .init(items: reslutItems)
    }

    
    /// 实际测试结果是需要同步实现配置数据的加载，否则选择配置后，数据无法回调到控制组件
    let dataItems = [Int](1...20).map { idx in
        return BaseControlWidgetEntity(
            id: UUID().uuidString,
            uuid: "customId_\(idx)",
            title: "样式\(idx)"
        )
    }

    /// 官方及现有网上教程是用一个函数来异步获取保存的配置信息，但实际是选择后,数据不会同步
    private func getItems() async throws -> [BaseControlWidgetEntity] {
        return dataItems
    }
}
