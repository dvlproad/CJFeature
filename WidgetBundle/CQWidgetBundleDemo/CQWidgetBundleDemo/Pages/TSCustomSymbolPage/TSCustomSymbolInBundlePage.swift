//
//  TSCustomSymbolPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//
//  测试在 SwiftUI 中，加载一张 .svg 格式的自定义 SF Symbols 图标。

import SwiftUI
import CJAnimationKit_Swift
import SwiftDraw

struct TSCustomSymbolInBundlePage: View {
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                Text("Asset外的 .svg 格式的自定义 SF Symbols 图标加载")
                
                ScrollView(.vertical) {
                    contentView
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color(hex: "#F5F5F5"))
            .padding(.top, 0)
            .padding(.bottom, 80)
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 10) {
            systemView1(name: "app_search_icon_byBundlePath.png")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            systemView1(name: "activity_byBundlePath.svg")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            systemView1(name: "icon_control_katong_6_byBundlePath.svg")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
        }
    }
    
    func systemView1(name: String) -> some View {
        HStack {
            VStack {
                Text("❌bunlde")
                if let downloadedBundle = TSResourceUtil.downloadedBundle {
                    Image(name, bundle: downloadedBundle)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(Color.randomColor)
                } else {
                    Text("Failed to load bundle")
                }
            }
            
            
            VStack {
                Text("✅ path")
                let downloadedBundle_UIImage = TSResourceUtil.downloadedBundle_UIImage(name: name)
                Image(uiImage: downloadedBundle_UIImage ?? UIImage())
                    .frame(width: 60, height: 60)
                    .background(Color.randomColor)
            }
            
//            VStack {
//                Text("❌bundle")
//                Image("emoji9_FFA5BE_byPath", bundle: nil)
//                    .frame(width: 60, height: 60)
//                    .background(Color.randomColor)
//            }
        }
    }
}
