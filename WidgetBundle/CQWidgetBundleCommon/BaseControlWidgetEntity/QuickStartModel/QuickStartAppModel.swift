//
//  QuickStartAppModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation
import AppIntents

public struct QuickStartAppModel: ControlWidgetBaseModel, Hashable {
    public static func == (lhs: QuickStartAppModel, rhs: QuickStartAppModel) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.saveId == rhs.saveId
        && lhs.appId == rhs.appId
        && lhs.appName == rhs.appName && lhs.appShowName == rhs.appShowName && lhs.appIcon == rhs.appIcon && lhs.targetUrl == rhs.targetUrl
    }
    
    var uuid: String = UUID().uuidString
//    var id = 0
    public var saveId: String?
    var appId: Int
    public var appName: String
    var appShowName: String
    var appIcon: String
//    var targetType: QuickStartType
    var targetUrl: String
    
    static func customAppModel(appName: String, appIcon: String = "", targetUrl: String) -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: appName,
            appShowName: appName,
            appIcon: appIcon,
            targetUrl: targetUrl
        )
    }
    
    init(appId: Int, appName: String, appShowName: String, appIcon: String, targetUrl: String) {
        self.appId = appId
        self.appName = appName
        self.appShowName = appShowName
        self.appIcon = appIcon
        self.targetUrl = targetUrl
    }
    
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case uuid
        case saveId
        case appId
        case appName
        case appShowName
        case appIcon
        case targetUrl
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? UUID().uuidString
        self.saveId = try container.decodeIfPresent(String.self, forKey: .saveId)
        self.appId = try container.decodeIfPresent(Int.self, forKey: .appId) ?? 0
        self.appName = try container.decodeIfPresent(String.self, forKey: .appName) ?? "app原名"
        self.appShowName = try container.decodeIfPresent(String.self, forKey: .appShowName) ?? "app展示名"
        self.appIcon = try container.decodeIfPresent(String.self, forKey: .appIcon) ?? ""
        self.targetUrl = try container.decodeIfPresent(String.self, forKey: .targetUrl) ?? ""
    }
    
    @available(iOS 18.0, *)
    static func tryOpenAppIntentResult(appUrl: String?) -> some IntentResult & OpensIntent {
        let appUrl: String = appUrl ?? "noexsitApp://"
        
        let appURL: URL? = URL(string: appUrl)
        return .result(opensIntent: appURL != nil ? OpenURLIntent(appURL!) : OpenURLIntent())
 
//        return noOpenAppIntentResult()
    }
    
    @available(iOS 18.0, *)
    static func noOpenAppIntentResult() -> some IntentResult & OpensIntent {
        //return .result()
        
        let appUrl: String = "noexsitApp://"
        
        let appURL: URL? = URL(string: appUrl)
        return .result(opensIntent: appURL != nil ? OpenURLIntent(appURL!) : OpenURLIntent())
    }
//
//
//    @available(iOS 18.0, *)
//    static func tryOpenURLIntent(appUrl: String?) -> OpensIntent {
//        if let appUrl = appUrl, let appURL = URL(string: appUrl) {
//            return OpenURLIntent(appURL)
//        }
//
//        return noOpenURLIntent()
//    }
//
//    @available(iOS 18.0, *)
//    static func noOpenURLIntent() -> OpensIntent {
//        return OpenURLIntent(URL(string: "noexsitApp://")!)
//    }
    
    // 日历App（模拟器就有）
    static public func calshowAppModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "日历",
            appShowName: "日历",
            appIcon: "",
            targetUrl: "calshow://"
        )
    }
    
    // 快捷指令App（模拟器就有）
    static public func shortcutsAppModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "快捷指令",
            appShowName: "快捷指令",
            appIcon: "",
            targetUrl: "shortcuts://"
        )
    }
    
    // 备忘录(真机才有）
    static public func mobilenotesAppModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "备忘录",
            appShowName: "备忘录",
            appIcon: "",
            targetUrl: "mobilenotes://"
        )
    }
    
    
    static func shortcutsUrlModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "快捷指令",
            appShowName: "快捷指令",
            appIcon: "",
            targetUrl: ShortcutsUtil.shortcutsUrl(shortcutsName: "添加新提醒事项")
        )
    }
    
    static func openWebAppModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "稀土掘金",
            appShowName: "稀土掘金",
            appIcon: "",
            targetUrl: "https://juejin.cn/"
        )
    }
    
    
}
