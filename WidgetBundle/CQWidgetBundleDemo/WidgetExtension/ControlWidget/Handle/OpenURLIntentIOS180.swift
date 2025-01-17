//
//  OpenURLIntentIOS180.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import AppIntents
import SwiftUI


@available(iOS 18.0, *)
struct OpenURLIntentIOS180: AppIntent {
    init() {
        
    }
    
    static let title: LocalizedStringResource = "OpenURLIntentIOS180"

    /// 此参数需要设为True否则不会打开主App，则应用跳转失效，且本类主Target也必须包含，否无无法触发perform
//    static var openAppWhenRun = true
    static var isDiscoverable = true
    
    @Parameter(title: "openUrl") var openUrl: String?
    init(openUrl: String? = nil) {
        self.openUrl = openUrl
    }

    func perform() async throws -> some IntentResult & OpensIntent {
        let appUrl: String = self.openUrl ?? "noexsitApp://"
        await EnvironmentValues().openURL(URL(string: appUrl)!)
#if Main_TARGET
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if let url = URL(string: "mobilenotes://") {
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    print("无法打开备忘录 app")
//                }
//            }
//        }
//        
//        if let url = URL(string: "mobilenotes://") {
//            // 使用后台任务或其他方法来尝试打开 URL
//            DispatchQueue.global(qos: .background).async {
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    print("无法打开备忘录 app")
//                }
//            }
//        }
#endif
        return .result()
    }
}
