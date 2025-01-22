//
//  TSTestHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/16.
//

import SwiftUI

struct TSTestHomePage: View {
    var body: some View {
        Text("TSTestHomePage")
        
        
        VStack(alignment: .leading, spacing: 10) {
            //*/
            NavigationLink(destination: TSCustomSymbolPage()) {
                Text("测试自定义Symbol")
            }
            NavigationLink(destination: TSLoadBundleResourceViewRepresentable()) {
                Text("测试 LoadBundleResourceView")
            }
            NavigationLink(destination: TSSwiftSVGLoadBundleResoureViewRepresentable()) {
                Text("测试 LoadBundleResource SwiftSVG")
            }
            NavigationLink(destination: TSCustomSymbolInBundlePage()) {
                Text("测试自定义Symbol in Bundle")
            }
            NavigationLink(destination: TSThirdSVGKitPage()) {
                Text("测试自定义Symbol SVGKit")
            }
            NavigationLink(destination: TSThirdSwiftSVGPage()) {
                Text("测试自定义Symbol SwiftSVG")
            }
            NavigationLink(destination: TSThirdSwiftDrawPage()) {
                Text("测试自定义Symbol SwiftDraw")
            }
            NavigationLink(destination: TSEasyAnimationView()) {
                Text("测试动画")
            }
            NavigationLink(destination: TSGifPage()) {
                Text("测试Gif")
            }
            
            NavigationLink(destination: TSQuickStartPage()) {
                Text("测试快捷启动")
            }

            Button(action: {
                if let savePath = TSWidgetResourceCacheUtil.copyImageToSharedDirectory(
                    imageName: "emoji9_FFA5BE_byPath",
                    imageExtension: "svg"
                ) {
                    CJTestUtil.sfsymbolPath_inShareDir = savePath
                    CJLogUtil.log("文件保存到的路径是:\(savePath)")
                } else {
                    CJLogUtil.log("文件保存失败")
                }
                
            }) {
                Text("测试加载共享资源目录中的 SF Symbol 图标")
            }
        }
    }
}
