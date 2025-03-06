//
//  QuickStartAppModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//

import Foundation
import AppIntents

public enum QuickStartType: String, Codable, CaseIterable, Sendable {
    case none       // 无操作
    case app        // 打开应用
    case shortcuts  // 打开快捷指令
    case web        // 打开网页
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = QuickStartType(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .none
        }
    }
}

struct QuickStartAppModel: ControlWidgetBaseModel, Hashable {
    static func == (lhs: QuickStartAppModel, rhs: QuickStartAppModel) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.saveId == rhs.saveId
        && lhs.appId == rhs.appId
        && lhs.appName == rhs.appName && lhs.appShowName == rhs.appShowName && lhs.appIcon == rhs.appIcon && lhs.targetUrl == rhs.targetUrl
    }
    
    var uuid: String = UUID().uuidString
//    var id = 0
    var saveId: String?
    var appId: Int
    var appName: String
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
    
    init(from decoder: Decoder) throws {
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
    static func calshowAppModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "日历",
            appShowName: "日历",
            appIcon: "",
            targetUrl: "calshow://"
        )
    }
    
    // 快捷指令App（模拟器就有）
    static func shortcutsAppModel() -> QuickStartAppModel {
        return QuickStartAppModel(
            appId: 0,
            appName: "快捷指令",
            appShowName: "快捷指令",
            appIcon: "",
            targetUrl: "shortcuts://"
        )
    }
    
    // 备忘录(真机才有）
    static func mobilenotesAppModel() -> QuickStartAppModel {
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

struct QuickStartShortcutsModel: ControlWidgetBaseModel, Hashable, Equatable {
    var shortcutsName: String
    var shortcutsText: String?
    
    var targetUrl: String
    
    /*
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case shortcutsName
        case shortcutsText
        case targetUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.shortcutsName = try container.decode(String.self, forKey: .shortcutsName)
        self.shortcutsText = try container.decodeIfPresent(String.self, forKey: .shortcutsText)
        self.targetUrl = try container.decode(String.self, forKey: .targetUrl)
    }
    */
}

struct QuickStartWebModel: ControlWidgetBaseModel, Hashable {
    var name: String

    var targetUrl: String
}

struct ShortcutsUtil {
    static func shortcutsUrl(shortcutsName: String) -> String {
//        let shortcutsName = "添加新提醒事项"
//        let shortcutsText = "Open List"
        let appUrl = "shortcuts://run-shortcut?name=\(shortcutsName)&input=text&text=\(shortcutsName)"
        return appUrl
    }
}
