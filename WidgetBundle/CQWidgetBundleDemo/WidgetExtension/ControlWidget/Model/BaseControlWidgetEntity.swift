//
//  BaseControlWidgetEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import AppIntents
import SwiftUI
import CJAnimationKit_Swift

// 组件的点击信息（功德组件需要使用，必要时候可能重置）
struct WidgetClickModel: Codable {
    var count: Int
    var lastClickDate: Date
    
    init() {
        self.count = 0
        self.lastClickDate = Date()
    }
}

struct WidgetImageScaleModel: AnimationModel, Codable {
    var type: AnimationType
    var isAnimating: Bool
    var animatingScale: CGFloat
    var duration: CGFloat
    
    init(type: AnimationType) {
        self.type = type
        self.isAnimating = false
        
        switch type {
        case .bounce:
            self.animatingScale = 1.2
            self.duration = 1.5
            break
        case .swing:
            self.animatingScale = 1.2
            self.duration = 1.5
            break
        case .rotate:
            self.animatingScale = 1.2
            self.duration = 1.5
            break
        case .woodenFish:
            self.animatingScale = 0.3
            self.duration = 3
            break
        case .breathe:
            self.animatingScale = 1.2
            self.duration = 1.5
            break
        case .pulse:
            self.animatingScale = 1.2
            self.duration = 1.5
            break
        case .none:
            self.animatingScale = 1.0
            self.duration = 0
            break
        }
    }
    
    init(type: AnimationType, duration: CGFloat, animatingScale: CGFloat) {
        self.type = type
        self.isAnimating = false
        self.animatingScale = animatingScale
        self.duration = duration
    }
}


struct BaseControlWidgetEntity: AppEntity, Codable {
    var displayRepresentation: DisplayRepresentation {
        let title = self.title
        let subTitle = self.subTitle
        let iconName = self.imageName
        return DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(subTitle)",
            image: .init(named: iconName, isTemplate: false)
        )
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "选择控制组件")
    
    typealias DefaultQuery = BaseControlWidgetEntityQuery
    static var defaultQuery: BaseControlWidgetEntityQuery = BaseControlWidgetEntityQuery()
    

    var id: String
    var saveId: String? // 保存到我的组件时候生成id
    var uuid: String
    var title: String
    var subTitle: String
    var imageName: String
    var isOn: Bool
    var clickModel: WidgetClickModel
    var onTintColorString: String?  // 选中时候的颜色
//    let imageAnimateType: String // 动画类型
    var animateModel: WidgetImageScaleModel
    
    init(id: String, uuid: String, title: String, subTitle: String, imageName: String, imageAnimateType: AnimationType) {
        self.id = id
        self.uuid = uuid
        self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
        self.isOn = false
        self.clickModel = WidgetClickModel()
//        self.imageAnimateType = imageAnimateType.rawValue
        self.animateModel = WidgetImageScaleModel(type: imageAnimateType)
    }
    
    var tintColor: Color? {
        if let onTintColorString = onTintColorString, onTintColorString.count > 0 {
            // 开启状态的图标颜色
            let themeColor = Color.orange
            return themeColor
        }
        
        return nil
    }
}




struct BaseControlWidgetEntityQuery: EntityQuery, EntityStringQuery {
    func suggestedEntities() async throws -> IntentItemCollection<BaseControlWidgetEntity> {
        //let dataItems = try await getItems()
        let dataItems: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getControlWidgets()
        return .init(items: dataItems)
    }
    
    func entities(for identifiers: [String]) async throws -> [BaseControlWidgetEntity] {
//        let dataItems = try await getItems()
        let dataItems: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getControlWidgets()
        return dataItems.filter({ entity in
            return identifiers.contains(entity.id)
        })
    }

    func entities(matching string: String) async throws -> IntentItemCollection<BaseControlWidgetEntity> {
//        let dataItems = try await getItems()
        let dataItems: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getControlWidgets()
        let reslutItems = dataItems.filter({ item in
            return (item.title).contains(string)
        })
        return .init(items: reslutItems)
    }

    
    /// 实际测试结果是需要同步实现配置数据的加载，否则选择配置后，数据无法回调到控制组件
    let dataItems = [Int](1...20).map { idx in
        return BaseControlWidgetEntity(
            id: UUID().uuidString,
            uuid: "customId_\(idx)",
            title: "样式呀\(idx)",
            subTitle: "xx类型",
            imageName: "",
            imageAnimateType: .none
        )
    }

    /// 官方及现有网上教程是用一个函数来异步获取保存的配置信息，但实际是选择后,数据不会同步
    private func getItems() async throws -> [BaseControlWidgetEntity] {
        return dataItems
        let entitys: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getControlWidgets()
        return entitys
    }
}
