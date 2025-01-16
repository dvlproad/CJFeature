//
//  CQWidgetBundleDemoApp.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI


@main
struct CQWidgetBundleDemoApp: App {
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
//                        CJLogUtil.log("想要跳转到\(urlStr)")
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
