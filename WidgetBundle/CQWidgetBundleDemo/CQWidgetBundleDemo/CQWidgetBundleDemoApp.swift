//
//  CQWidgetBundleDemoApp.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CQWidgetBundle

// 使用 EnvironmentObject（全局导航）
// 1. 定义导航管理器
class NavigationManager: ObservableObject {
    @Published var navigateToDetail = false
    @Published var selectedLayoutId = ""
    
    func navigateToDetail(with id: String) {
        selectedLayoutId = id
        navigateToDetail = true
    }
}

@main
struct CQWidgetBundleDemoApp: App {
    @StateObject private var navManager = NavigationManager()
    
    // 最先执行：init()
    init() {
        print("App 初始化")
        // 在这里做早期配置
        CQControlWidgetMyCollectionViewCell.deleteControlWidgetEntityWithSaveId = { saveId in
            TSWidgetBundleCacheUtil.deleteControlWidgetEntityWithSaveId(saveId)
        }
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            
            homePage
        }
    }
    
    var homePage: some View {
        TSHomePage()
            .onOpenURL { url in
                handleURL(url)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("openUrlViaWidget"))) { notify in
                if let object = notify.object as? [String: Any],
                   let urlStr = object["url"] as? String,
                   
                   let url = URL(string: urlStr){
                    //appJump(url: url)
//                        CCLogUtil.log("想要跳转到\(urlStr)")
                    print("跳转成功\(notify)")
                }else{
                    print("跳转失败\(notify)")
                }
            }
    }
    
    private func handleURL(_ url: URL) {
        if url.scheme == "cqWidgetBundleDemo" {
            // 处理打开应用后的逻辑，例如导航到某个界面
            print("App opened with URL: \(url)")
        }
    }
}
