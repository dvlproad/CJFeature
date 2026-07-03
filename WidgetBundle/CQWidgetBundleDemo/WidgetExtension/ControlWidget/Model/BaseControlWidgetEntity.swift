//
//  BaseControlWidgetEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJAnimationKit_Swift

protocol ControlWidgetBaseModel: Codable {
    
}


// 组件的点击信息（功德组件需要使用，必要时候可能重置）
struct WidgetClickModel: ControlWidgetBaseModel, Hashable {
    var count: Int
    var lastClickDate: Date
    
    init() {
        self.count = 0
        self.lastClickDate = Date()
    }
}

public struct IconColorModel: ControlWidgetBaseModel, Hashable, Sendable {
    public static func == (lhs: IconColorModel, rhs: IconColorModel) -> Bool {
        return lhs.index == rhs.index && lhs.colorString == rhs.colorString
    }
    
    var index: Int          // 颜色下标
    var colorString: String

    init(index: Int = -1, colorString: String) {
        self.index = index
        self.colorString = colorString
    }

    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case index
        case colorString
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.index = try container.decodeIfPresent(Int.self, forKey: .index) ?? 0
        self.colorString = try container.decode(String.self, forKey: .colorString)
    }
}


struct CJControlWidgetOnOffModel: ControlWidgetBaseModel, Hashable, Sendable {
    var title: String
    var subTitle: String
    var imageModel: CJBaseImageModel
    var imageColorModel: IconColorModel?
    
    var editingQuickStartType: QuickStartType = .none  // 默认选中第几个（可能几个选项都有值，但是最后只生效一个）；此值后台可提供也可不提供，若未提供前端自己推算
    var appModel: QuickStartAppModel?
    var shortcutsModel: QuickStartShortcutsModel?
    var webModel: QuickStartWebModel?
    
    static func == (lhs: CJControlWidgetOnOffModel, rhs: CJControlWidgetOnOffModel) -> Bool {
        return lhs.title == rhs.title && lhs.subTitle == rhs.subTitle
        && lhs.imageModel == rhs.imageModel && lhs.imageColorModel == rhs.imageColorModel
        && lhs.appModel == rhs.appModel && lhs.shortcutsModel == rhs.shortcutsModel && lhs.webModel == rhs.webModel
        && lhs.editingQuickStartType == rhs.editingQuickStartType
    }
    
    init(title: String,
         subTitle: String,
         imageModel: CJBaseImageModel,
         imageColorModel: IconColorModel?
    ) {
        self.title = title
        self.subTitle = subTitle
        self.imageModel = imageModel
        self.imageColorModel = imageColorModel
    }
    
    static func defaultOffModel() -> CJControlWidgetOnOffModel {
        return CJControlWidgetOnOffModel(
            title: "",
            subTitle: "",
            imageModel: CJBaseImageModel(id: "", name: "", imageName: ""),
            imageColorModel: nil
        )
    }
    
    func getQuickStartType() -> QuickStartType {
        var quickStartType: QuickStartType
        if self.appModel != nil {
            quickStartType = .app
        } else if self.shortcutsModel != nil {
            quickStartType = .shortcuts
        } else if self.webModel != nil {
            quickStartType = .web
        } else {
            quickStartType = .none
        }
        return quickStartType
    }
    
    func getOpenUrl() -> String? {
        if let appModel = appModel {
            return appModel.targetUrl
        }
        
        if let shortcutsModel = shortcutsModel {
            return shortcutsModel.targetUrl
        }
        
        if let webModel = webModel {
            return webModel.targetUrl
        }
        
        return nil
    }
    
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case title
        case subTitle
        case imageModel
        case imageColorModel
//        case quickStartType
        case appModel
        case shortcutsModel
        case webModel
    }
    
    // 自定义解码器以处理默认值
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.subTitle = try container.decodeIfPresent(String.self, forKey: .subTitle) ?? ""
        self.imageModel = try container.decode(CJBaseImageModel.self, forKey: .imageModel)
        self.imageColorModel = try container.decodeIfPresent(IconColorModel.self, forKey: .imageColorModel)
        
        self.appModel = try container.decodeIfPresent(QuickStartAppModel.self, forKey: .appModel)
        self.shortcutsModel = try container.decodeIfPresent(QuickStartShortcutsModel.self, forKey: .shortcutsModel)
        self.webModel = try container.decodeIfPresent(QuickStartWebModel.self, forKey: .webModel)
        
//        let quickStartType = try container.decodeIfPresent(QuickStartType.self, forKey: .quickStartType)
//        if let quickStartType = quickStartType {
//            self.editingQuickStartType = quickStartType
//        } else {
            self.editingQuickStartType = self.getQuickStartType()
//        }
    }
    
}

/// 组件套
struct BaseControlWidgetSetModel: ControlWidgetBaseModel, Hashable {
    var id: String
    var name: String
    var entitys: [BaseControlWidgetEntity]
}


public struct BaseControlWidgetEntity: ControlWidgetBaseModel, Hashable, Identifiable, Sendable {
    public static func == (lhs: BaseControlWidgetEntity, rhs: BaseControlWidgetEntity) -> Bool {
        return lhs.widgetId == lhs.widgetId
        && lhs.saveId == rhs.saveId && lhs.id == rhs.id
        && lhs.onModel == rhs.onModel && lhs.offModel == rhs.offModel && lhs.isOn == rhs.isOn
        && lhs.isOffInDetailPage == rhs.isOffInDetailPage
        && lhs.symbolEffectType == rhs.symbolEffectType
        && lhs.widgetType == rhs.widgetType && lhs.widgetStyle == rhs.widgetStyle
        && lhs.bgColorString == rhs.bgColorString
    }
    
    
    var widgetId: String    // 后台给的 widgetId 名字不要用 id ,避免添加多个组件到桌面后，在桌面选择组件时候会选中多个相同id
    public var id: String
    
    var saveId: String? // 保存到我的组件时候生成id
    var samePosition: Int? // 保存到我的组件时候生成,此组件被添加的次数(可添加多个)，第一个值为1
    var onModel: CJControlWidgetOnOffModel
    var offModel: CJControlWidgetOnOffModel?
    var isOn: Bool = true          // 后台不返回，默认true
    var isOffInDetailPage: Bool?
    var clickModel: WidgetClickModel?
//    let imageAnimateType: String // 动画类型
//    var symbolEffectTypeString: String?
    var symbolEffectType: SymbolEffectType = .none
    
    var name: String
    var widgetType: ControlWidgetType?
    var widgetStyle: ControlWidgetStyle // 在app内的形态（控制中心不提供获取）
    var bgColorString: String?          // 在app内的背景色，为空时候用白色（控制中心没有背景色）
    
    // 执行处理
    var quickStartEnable: Bool?     // 是否是快捷启动的组件（支持才有选项）
    
    var playSoundEnable: Bool?      // 是否允许播放音乐
    
    func nameWithNumber() -> String {
        let samePosition = samePosition ?? 0
        let samePositionText = " #\(samePosition)"
        let text = "\(name)\(samePositionText)"  //TODO: qian
        return text
    }
    
    func getStateModel() -> CJControlWidgetOnOffModel {
        return (offModel != nil && isOn == false) ? offModel! : onModel
    }
    
    static func defaultEntityForDesktopType(_ desktopWidgetControlType: DesktopWidgetControlType) -> BaseControlWidgetEntity {
        var widgetInfoModel = BaseControlWidgetEntity(
            widgetId: UUID().uuidString,
            title: desktopWidgetControlType == .quickStart ? "快捷启动" : "控制组件",
            subTitle: "还未选择组件",
            imageModel: CJBaseImageModel(
                id: "",
                name: "",
                imageName: desktopWidgetControlType == .quickStart ? "preview_button" : "preview_toggle"
            ), // previewValue 展示的图片
            symbolEffectType: .none,
            name: "",
            widgetStyle: .circle,
            bgColorString: "#B1E1234F"
        )
        widgetInfoModel.id = widgetInfoModel.widgetId
        
        return widgetInfoModel
    }
    
    init(widgetId: String,
         title: String,
         subTitle: String,
         imageModel: CJBaseImageModel,
         symbolEffectType: SymbolEffectType = .none,
         name: String,
         widgetStyle: ControlWidgetStyle,
         bgColorString: String?
    ) {
        self.widgetId = widgetId
        self.id = widgetId // 默认值要使用 widgetId，避免根据id进行选中与取消的套图列表页因为使用相同默认值而导致全选的问题
        
        self.onModel = CJControlWidgetOnOffModel(
            title: title,
            subTitle: subTitle,
            imageModel: imageModel,
            imageColorModel: nil
        )
        self.offModel = CJControlWidgetOnOffModel(
            title: title,
            subTitle: subTitle,
            imageModel: imageModel,
            imageColorModel: nil
        )
        self.isOn = false
        self.clickModel = WidgetClickModel()
//        self.imageAnimateType = imageAnimateType.rawValue
        
        self.name = name
        self.widgetStyle = widgetStyle
        self.bgColorString = bgColorString  // Color.randomColor.toHex(includeAlpha: true)
    }
    
    // 【【IOS18控制中心】控制中心，几个地方的图标显示需要优化】https://www.tapd.cn/tapd_fe/66656887/bug/detail/1166656887001001589
    var alwaysDisableTintColor: Bool {
        return quickStartEnable == true
    }
    
    // 开启状态时候标题的颜色，固定取 onModel 中的值
    var tintColor: Color? {
        if let imageColorModel = onModel.imageColorModel {
            let tintColor = Color(hex: imageColorModel.colorString)
            return tintColor
        }
        
        if let imageColorString = onModel.imageModel.imageColorString {
            let tintColor = Color(hex: imageColorString)
            return tintColor
        }
        
        return nil
    }
    
    /// 桌面控制中心选择时候显示
    public func displayImageData() -> Data? {
        let onoffModel = self.onModel
        
        //var image = .init(named: iconName, isTemplate: false)
        let uiimage = onoffModel.imageModel.crateDisplayUIImage()
        guard let uiimage = uiimage else {
            return nil
        }
        
        
        var tintUIColor: UIColor?
        var bgColor: UIColor
        if self.quickStartEnable == true {
            tintUIColor = UIColor.white.withAlphaComponent(0.8)
            bgColor = UIColor(hex: "#4C000000", alpha: 1.0)
        } else {
            if let imageColorModel = onoffModel.imageColorModel {
                tintUIColor = UIColor(hex: imageColorModel.colorString)
            } else if let imageColorString = onoffModel.imageModel.imageColorString {
                tintUIColor = UIColor(hex: imageColorString)
            }
            //tintUIColor = tintColor != nil ? UIColor(tintColor!) : nil
            bgColor = UIColor.white
        }
        let lastuiimage: UIImage = UIImage.getControlWidgetUIImageFrom(uiimage, tintColor: tintUIColor, bgColor: bgColor)
        guard let imageData = lastuiimage.pngData() else {
            return nil
        }
        
        //print("成功获取图片数据，大小：\(imageData.count) 字节")
        return imageData
    }
    
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case widgetId = "widgetId"
        case id
        case saveId
        case samePosition
        case onModel
        case offModel
        case isOn
        case clickModel
        case symbolEffectType
        case name
        case widgetType
        case widgetStyle
        case bgColorString
        case quickStartEnable
    }
    
    // 自定义解码器以处理默认值
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.widgetId = try container.decode(String.self, forKey: .widgetId)
        self.onModel = try container.decode(CJControlWidgetOnOffModel.self, forKey: .onModel)
        self.offModel = try container.decodeIfPresent(CJControlWidgetOnOffModel.self, forKey: .offModel)
        self.isOn = try container.decodeIfPresent(Bool.self, forKey: .isOn) ?? true
        self.clickModel = try container.decodeIfPresent(WidgetClickModel.self, forKey: .clickModel) ?? WidgetClickModel()
        self.name = try container.decode(String.self, forKey: .name)
        self.widgetType = try container.decodeIfPresent(ControlWidgetType.self, forKey: .widgetType) ?? .unknown
        self.widgetStyle = try container.decode(ControlWidgetStyle.self, forKey: .widgetStyle)
        self.bgColorString = try container.decodeIfPresent(String.self, forKey: .bgColorString)
        self.symbolEffectType = try container.decodeIfPresent(SymbolEffectType.self, forKey: .symbolEffectType) ?? .none
        
        self.quickStartEnable = try container.decodeIfPresent(Bool.self, forKey: .quickStartEnable)
        
        // 非后台字段
        self.saveId = try container.decodeIfPresent(String.self, forKey: .saveId)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? self.widgetId  // 默认值要使用 widgetId，避免根据id进行选中与取消的套图列表页因为使用相同默认值而导致全选的问题
        self.samePosition = try container.decodeIfPresent(Int.self, forKey: .samePosition)
    }
    
    
    // 创建一个副本并设置新的类型,预览的时候需要同时显示三种样式
    func copyWithNewWidgetStyle(_ widgetStyle: ControlWidgetStyle) -> BaseControlWidgetEntity {
        var newEntity = self
        newEntity.widgetStyle = widgetStyle
        return newEntity
    }
}
