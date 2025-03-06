//
//  OpenURLIntentIOS182.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import AppIntents
import SwiftUI

@available(iOS 18.1, *)
struct OpenURLIntentIOS181: AppIntent, OpensIntent {
    var value: Never?
    
    init() {
        
    }
    
    static let title: LocalizedStringResource = "OpenURLIntentIOS181"

    
    @Parameter(title: "openUrl") var openUrl: String?
    init(openUrl: String? = nil) {
        self.openUrl = openUrl
    }

    func perform() async throws -> some IntentResult & OpensIntent {
        let appUrl: String = self.openUrl ?? "noexsitApp://"
        
        let appURL: URL? = URL(string: appUrl)
        if let appURL = appURL {
            await EnvironmentValues().openURL(appURL) // kn:使用此行修复使用 OpenURLIntent 打开非系统应用无效问题
        }
        
        return .result(opensIntent: appURL != nil ? OpenURLIntent(appURL!) : OpenURLIntent())   //(日历有效，微信无效)
    }
}
