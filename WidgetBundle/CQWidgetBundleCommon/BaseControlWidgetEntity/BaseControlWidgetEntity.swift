//
//  BaseControlWidgetEntity.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation
import SwiftUI
import CJAnimationKit_Swift // 需要 SymbolEffectType
import CJBaseUIKit_Swift    // 需要 Color(hex:

public protocol ControlWidgetBaseModel: Codable {
    
}

public struct BaseControlWidgetEntity: ControlWidgetBaseModel, Hashable, Identifiable, Sendable {
    public static func == (lhs: BaseControlWidgetEntity, rhs: BaseControlWidgetEntity) -> Bool {
        return lhs.widgetId == rhs.widgetId
        && lhs.saveId == rhs.saveId && lhs.id == rhs.id
        && lhs.onModel == rhs.onModel && lhs.offModel == rhs.offModel && lhs.isOn == rhs.isOn
        && lhs.isOffInDetailPage == rhs.isOffInDetailPage
        && lhs.symbolEffectType == rhs.symbolEffectType
        && lhs.widgetType == rhs.widgetType && lhs.widgetStyle == rhs.widgetStyle
        && lhs.bgColorString == rhs.bgColorString
    }
    
    
    public var widgetId: String    // 后台给的 widgetId 名字不要用 id ,避免添加多个组件到桌面后，在桌面选择组件时候会选中多个相同id
    public var id: String
    
    public var saveId: String? // 保存到我的组件时候生成id
    public var samePosition: Int? // 保存到我的组件时候生成,此组件被添加的次数(可添加多个)，第一个值为1
    public var onModel: CJControlWidgetOnOffModel
    public var offModel: CJControlWidgetOnOffModel?
    public var isOn: Bool = true          // 后台不返回，默认true
    public var isOffInDetailPage: Bool?
    public var clickModel: WidgetClickModel?
//    let imageAnimateType: String // 动画类型
//    var symbolEffectTypeString: String?
    public var symbolEffectType: SymbolEffectType = .none
    
    public var name: String
    public var widgetType: ControlWidgetType?
    public var widgetStyle: ControlWidgetStyle // 在app内的形态（控制中心不提供获取）
    public var bgColorString: String?          // 在app内的背景色，为空时候用白色（控制中心没有背景色）
    
    // 执行处理
    public var quickStartEnable: Bool?     // 是否是快捷启动的组件（支持才有选项）
    
    public var playSoundEnable: Bool?      // 是否允许播放音乐
    
    public func nameWithNumber() -> String {
        let samePosition = samePosition ?? 0
        let samePositionText = " #\(samePosition)"
        let text = "\(name)\(samePositionText)"  //TODO: qian
        return text
    }
    
    public func getStateModel() -> CJControlWidgetOnOffModel {
        return (offModel != nil && isOn == false) ? offModel! : onModel
    }
    
    static public func defaultEntityForDesktopType(_ desktopWidgetControlType: DesktopWidgetControlType) -> BaseControlWidgetEntity {
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
            bgColorString: "#93b3a3"
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
    public var alwaysDisableTintColor: Bool {
        return quickStartEnable == true
    }
    
    // 开启状态时候标题的颜色，固定取 onModel 中的值
    public var tintColor: Color? {
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
    public func copyWithNewWidgetStyle(_ widgetStyle: ControlWidgetStyle) -> BaseControlWidgetEntity {
        var newEntity = self
        newEntity.widgetStyle = widgetStyle
        return newEntity
    }
}
