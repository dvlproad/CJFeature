//
//  OpenURLIntentIOS182.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import AppIntents

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
        
        return .result(opensIntent: OpenURLIntent(URL(string: appUrl)!))
    }
}
