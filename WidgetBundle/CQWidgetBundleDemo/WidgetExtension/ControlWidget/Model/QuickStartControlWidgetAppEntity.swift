//
//  QuickStartControlWidgetAppEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/13.
//

import AppIntents
import CQWidgetBundleCommon

@available(iOS 16, *)
struct QuickStartControlWidgetAppEntity: AppEntity, ControlWidgetBaseModel, Hashable {
    typealias DefaultQuery = QuickStartControlWidgetAppEntityQuery
    static var defaultQuery: QuickStartControlWidgetAppEntityQuery = QuickStartControlWidgetAppEntityQuery()
    
    static func == (lhs: QuickStartControlWidgetAppEntity, rhs: QuickStartControlWidgetAppEntity) -> Bool {
        return lhs.id == lhs.id
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
    
    static func defaultEntity() -> QuickStartControlWidgetAppEntity {
        return QuickStartControlWidgetAppEntity(
            widgetInfo: BaseControlWidgetEntity.defaultEntityForDesktopType(.quickStart)
        )
    }
}


@available(iOS 16.0, *)
struct QuickStartControlWidgetAppEntityQuery: EntityQuery, EntityStringQuery {
    func suggestedEntities() async throws -> IntentItemCollection<QuickStartControlWidgetAppEntity> {
        let dataItems = getItems()
        return .init(items: dataItems)
    }
    
    func entities(for identifiers: [String]) async throws -> [QuickStartControlWidgetAppEntity] {
        let dataItems = getItems()
        return dataItems.filter({ entity in
            return identifiers.contains(entity.widgetInfo.id)
        })
    }

    func entities(matching string: String) async throws -> IntentItemCollection<QuickStartControlWidgetAppEntity> {
        let dataItems = getItems()
        let reslutItems = dataItems.filter({ item in
            return (item.widgetInfo.name).contains(string)
        })
        return .init(items: reslutItems)
    }

    private func getItems() -> [QuickStartControlWidgetAppEntity] {
        var appEntitys: [QuickStartControlWidgetAppEntity] = []
        
        let entitys: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getCacheControlWidgets(.quickStart)
        for entity in entitys {
            var appEntity = QuickStartControlWidgetAppEntity(widgetInfo: entity)
            appEntity.id = entity.id
            appEntitys.append(appEntity)
        }
        
        appEntitys.reverse()    // 反转数组，使顺序倒置。后添加的先显示
        
        return appEntitys
    }
}
