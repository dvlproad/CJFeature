//
//  CJControlWidgetOnOffModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation


public struct CJControlWidgetOnOffModel: ControlWidgetBaseModel, Hashable, Sendable {
    public var title: String
    public var subTitle: String
    public var imageModel: CJBaseImageModel
    public var imageColorModel: IconColorModel?
    
    public var editingQuickStartType: QuickStartType = .none  // 默认选中第几个（可能几个选项都有值，但是最后只生效一个）；此值后台可提供也可不提供，若未提供前端自己推算
    public var appModel: QuickStartAppModel?
    public var shortcutsModel: QuickStartShortcutsModel?
    public var webModel: QuickStartWebModel?
    
    public static func == (lhs: CJControlWidgetOnOffModel, rhs: CJControlWidgetOnOffModel) -> Bool {
        return lhs.title == rhs.title && lhs.subTitle == rhs.subTitle
        && lhs.imageModel == rhs.imageModel && lhs.imageColorModel == rhs.imageColorModel
        && lhs.appModel == rhs.appModel && lhs.shortcutsModel == rhs.shortcutsModel && lhs.webModel == rhs.webModel
        && lhs.editingQuickStartType == rhs.editingQuickStartType
    }
    
    public init(title: String,
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
    
    public func getOpenUrl() -> String? {
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
    public init(from decoder: Decoder) throws {
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
