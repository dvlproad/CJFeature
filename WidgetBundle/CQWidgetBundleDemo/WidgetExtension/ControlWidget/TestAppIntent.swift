//
//  TestAppIntent.swift
//  WidgetExtensionExtension
//
//  Created by qian on 2025/1/10.
//

import ActivityKit
import AppIntents
import SwiftUI

@available(iOS 16, *)
struct TestAppIntent: AudioPlaybackIntent {
    
    static var title: LocalizedStringResource = "TestAppIntent Task"
    static var description: IntentDescription = IntentDescription("TestAppIntent Task")
    
    @Parameter(title: "widgetId") var widgetId: String?
    
    init() { }
    init(widgetId: String) {
        self.widgetId = widgetId
    }
    
    func perform() async throws -> some IntentResult {
        //print("您点击了: \(widgetId ?? "") date: \(Date().format("HH:mm:ss"))")
        
        let appUrl: String = "weixin://"
        let appURL: URL? = URL(string: appUrl)
        if let appURL = appURL {
            await EnvironmentValues().openURL(appURL) // kn:使用此行修复使用 OpenURLIntent 打开非系统应用无效问题
        }
        
        return .result()
    }
}
