//
//  BaseControlWidgetEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import AppIntents
import SwiftUI
import CJAnimationKit_Swift

protocol ControlWidgetBaseModel: Codable {
    
}


// 组件的点击信息（功德组件需要使用，必要时候可能重置）
struct WidgetClickModel: ControlWidgetBaseModel {
    var count: Int
    var lastClickDate: Date
    
    init() {
        self.count = 0
        self.lastClickDate = Date()
    }
}

struct WidgetImageScaleModel: AnimationModel, ControlWidgetBaseModel {
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


struct BaseControlWidgetEntity: AppEntity, ControlWidgetBaseModel {
    /*
    static func == (lhs: BaseControlWidgetEntity, rhs: BaseControlWidgetEntity) -> Bool {
        return lhs.id == lhs.id && lhs.saveId == rhs.saveId
        && lhs.title == rhs.title && lhs.subTitle == rhs.subTitle && lhs.imageModel == rhs.imageModel
        && lhs.isOn == rhs.isOn
        && lhs.symbolEffectType == rhs.symbolEffectType
        && lhs.widgetStyle == rhs.widgetStyle
        && lhs.bgColorString == rhs.bgColorString
    }
    */
    
    @available(iOS 16.0, *)
    var displayRepresentation: DisplayRepresentation {
        let title = self.title
        let subTitle = self.subTitle
        let iconName = self.imageModel.imageName
        return DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(subTitle)",
            image: .init(named: iconName, isTemplate: false)
        )
    }
    
    @available(iOS 16, *)
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "选择控制组件")
    
    @available(iOS 16.0, *)
    typealias DefaultQuery = BaseControlWidgetEntityQuery
    @available(iOS 16.0, *)
    static var defaultQuery: BaseControlWidgetEntityQuery = BaseControlWidgetEntityQuery()
    

    var id: String
    var saveId: String? // 保存到我的组件时候生成id
    var title: String
    var subTitle: String
    var imageModel: CJBaseImageModel
    var isOn: Bool
    var clickModel: WidgetClickModel
    var onTintColorString: String?  // 选中时候的颜色
//    let imageAnimateType: String // 动画类型
    var animateModel: WidgetImageScaleModel
//    var symbolEffectTypeString: String?
    var symbolEffectType: SymbolEffectType = .none
    
    var name: String
    var widgetStyle: ControlWidgetType  // 在app内的形态（控制中心不提供获取）
    var bgColorString: String           // 在app内的背景色（控制中心没有背景色）
    
    // 执行处理
    var appModel: QuickStartAppModel?
    var shortcutsModel: QuickStartShortcutsModel?
    var webModel: QuickStartWebModel?
    
    static func nilEntity() -> BaseControlWidgetEntity {
        return BaseControlWidgetEntity(
            id: UUID().uuidString,
            title: "控制组件",
            subTitle: "我是副标题",
            imageModel: CJBaseImageModel(id: "", name: "", imageName: ""),
            imageAnimateType: .none,
            name: "",
            widgetStyle: .circle,
            bgColorString: "#ff0000"
        )
    }
    
    init(id: String,
         title: String,
         subTitle: String,
         imageModel: CJBaseImageModel,
         imageAnimateType: AnimationType,
         name: String,
         widgetStyle: ControlWidgetType,
         bgColorString: String
    ) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.imageModel = imageModel
        self.isOn = false
        self.clickModel = WidgetClickModel()
//        self.imageAnimateType = imageAnimateType.rawValue
        self.animateModel = WidgetImageScaleModel(type: imageAnimateType)
        
        self.name = name
        self.widgetStyle = widgetStyle
        self.bgColorString = bgColorString  // Color.randomColor.toHex(includeAlpha: true)
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




@available(iOS 16.0, *)
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
            title: "样式呀\(idx)",
            subTitle: "xx类型",
            imageModel: CJBaseImageModel(id: "", name: "", imageName: ""),
            imageAnimateType: .none,
            name: "yyyyy",
            widgetStyle: .circle,
            bgColorString: "#ff0000"
        )
    }

    /// 官方及现有网上教程是用一个函数来异步获取保存的配置信息，但实际是选择后,数据不会同步
    private func getItems() async throws -> [BaseControlWidgetEntity] {
        return dataItems
        let entitys: [BaseControlWidgetEntity] = TSWidgetBundleCacheUtil.getControlWidgets()
        return entitys
    }
}
