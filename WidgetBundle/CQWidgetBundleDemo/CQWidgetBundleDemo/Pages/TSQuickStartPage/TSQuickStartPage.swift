//
//  TSQuickStartPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/16.
//

import SwiftUI

struct TSQuickStartPage: View {
    var body: some View {
        Text("测试快捷启动")
        
        Button {
            let appUrl = "calshow://"   // 日历（模拟器就有）
            //let appUrl = "mobilenotes://"   // 备忘录(真机才有）
    //        let appUrl = "cqWidgetBundleDemo://"
    #if Main_TARGET
            if let url = URL(string: appUrl) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("无法打开【 \(appUrl) 】应用，可能未安装或损坏。请尝试重启设备或重新安装备忘录应用。")
                }
            }
    #endif
            
        } label: {
            Text("打开日历")
        }
        
        VStack(alignment: .leading, spacing: 10) {
            // 测试快捷启动的按钮
            Button(action: {
                let appUrl = "calshow://"   // 日历（模拟器就有）
                //let appUrl = "mobilenotes://"   // 备忘录(真机才有）
        //        let appUrl = "cqWidgetBundleDemo://"
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动：日历（模拟器就有）")
            }
            
            Button(action: {
                let appUrl = "shortcuts://"     // 快捷指令
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动：快捷指令首页（模拟器就有）")
            }
            
            Button(action: {
                // "shortcuts://run-shortcut?name=[名称]&input=[输入]&text=[文本]"
                let shortcutsName = "添加新提醒事项"
                let shortcutsText = "Open List"
                let appUrl = "shortcuts://run-shortcut?name=\(shortcutsName)&input=text&text=\(shortcutsName)"
//                let appUrl = "shortcuts://run-shortcut?name=Lookup%20Goetta&input=text&text=goetta%20is%20great"
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动：快捷指令指定（模拟器就有）")
            }
            
            Button(action: {
                let appUrl = "mobilenotes://"   // 备忘录
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动:备忘录(真机才有）")
            }
        }
    }
}
