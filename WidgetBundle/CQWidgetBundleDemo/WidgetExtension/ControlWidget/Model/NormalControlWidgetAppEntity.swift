//
//  NormalControlWidgetAppEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import AppIntents

@available(iOS 16, *)
struct BaseControlWidgetAppEntity: AppEntity, ControlWidgetBaseModel, Hashable {
    typealias DefaultQuery = BaseControlWidgetEntityQuery
    static var defaultQuery: BaseControlWidgetEntityQuery = BaseControlWidgetEntityQuery()
    
    static func == (lhs: BaseControlWidgetAppEntity, rhs: BaseControlWidgetAppEntity) -> Bool {
        return lhs.id == rhs.id
        && lhs.widgetInfo == rhs.widgetInfo
    }
    
    var displayRepresentation: DisplayRepresentation {
        let onoffModel = self.widgetInfo.getStateModel()
        //let title = onoffModel.title
        //let subTitle = onoffModel.subTitle
        
        //var image = .init(named: iconName, isTemplate: false)
        var displayImage: DisplayRepresentation.Image?
        if let imageData = self.widgetInfo.displayImageData() {
            displayImage = DisplayRepresentation.Image(data: imageData, isTemplate: false)
        }
        
        return DisplayRepresentation(
            title: "\(self.widgetInfo.nameWithNumber())",
            //title: "\(title)\(samePositionText)",   //TODO: qian
            //subtitle: "\(subTitle)",
            image: displayImage
        )
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "选择控制组件")
    
    
    
    var id: String = "noid_when_nosave"
    // 手动实现 EntityIdentifierConvertible 协议
    var entityIdentifier: String {
        return id
    }
    var widgetInfo: BaseControlWidgetEntity
    
    static func defaultEntity() -> BaseControlWidgetAppEntity {
        return BaseControlWidgetAppEntity(
            widgetInfo: BaseControlWidgetEntity.defaultEntityForDesktopType(.toggle)
        )
    }
}


@available(iOS 16.0, *)
struct BaseControlWidgetEntityQuery: EntityQuery, EntityStringQuery {
    func suggestedEntities() async throws -> IntentItemCollection<BaseControlWidgetAppEntity> {
        let dataItems = getItems()
        return .init(items: dataItems)
    }
    
    func entities(for identifiers: [String]) async throws -> [BaseControlWidgetAppEntity] {
        let dataItems = getItems()
        let matched = dataItems.filter({ entity in
            return identifiers.contains(entity.widgetInfo.id)
        })
        return matched
    }

    func entities(matching string: String) async throws -> IntentItemCollection<BaseControlWidgetAppEntity> {
        let dataItems = getItems()
        let reslutItems = dataItems.filter({ item in
            return (item.widgetInfo.name).contains(string)
        })
        return .init(items: reslutItems)
    }

    private func getItems() -> [BaseControlWidgetAppEntity] {
        var appEntitys: [BaseControlWidgetAppEntity] = []
        
        //let entitys: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getCacheControlWidgets(.toggle)
        let entitys: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getCacheControlWidgets(.all) // 不区分控制和启动组件
        for entity in entitys {
            var appEntity = BaseControlWidgetAppEntity(widgetInfo: entity)
            appEntity.id = entity.id
            appEntitys.append(appEntity)
        }
        
        appEntitys.reverse()    // 反转数组，使顺序倒置。后添加的先显示
        
        return appEntitys
    }
}
