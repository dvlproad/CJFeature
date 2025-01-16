//
//  QuickStartAppModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//

import Foundation
import AppIntents

struct QuickStartAppModel: Codable {
    var appId: Int
    var appName: String
    var appShowName: String
    var appIcon: String
    var targetUrl: String
    
    @available(iOS 18.0, *)
    static func tryOpenAppIntentResult(appUrl: String?) -> some IntentResult & OpensIntent {
        if let appUrl = appUrl, let appURL = URL(string: appUrl)  {
            return .result(opensIntent: OpenURLIntent(appURL))
        }
        
//        return noOpenAppIntentResult()
        return .result(opensIntent: OpenURLIntent(URL(string: "noexsitApp://")!))
    }
    
    @available(iOS 18.0, *)
    static func noOpenAppIntentResult() -> some IntentResult & OpensIntent {
        //return .result()
        return .result(opensIntent: OpenURLIntent(URL(string: "noexsitApp://")!))
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

struct ShortcutsUtil {
    static func shortcutsUrl(shortcutsName: String) -> String {
//        let shortcutsName = "添加新提醒事项"
//        let shortcutsText = "Open List"
        let appUrl = "shortcuts://run-shortcut?name=\(shortcutsName)&input=text&text=\(shortcutsName)"
        return appUrl
    }
}
