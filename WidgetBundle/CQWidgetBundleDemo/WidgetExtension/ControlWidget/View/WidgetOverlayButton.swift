//
//  WidgetOverlayButton.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/16.
//
//  覆盖在组件上面的按钮（用来做操作）

import SwiftUI

struct WidgetOverlayButton: View {
    var forWidgetId: String
    var pageInfo: CQPageInfo?
    var onTap: @Sendable () -> Void
    
    var body: some View {
        if isInWidget {
            if #available(iOS 17.0, *) {
                let appIntent = AudioSystemIntent(widgetId: forWidgetId)
                
                Button(intent: appIntent) {
                    Color.clear
                }
                .buttonStyle(.borderless)
                
                
                
            }
        } else if currentPageType == .widgetDetailPage { // app内在详情页时候，可点击界面任意点进行开关
            GeometryReader(content: { geometry in
                Button(action: {
                    debugPrint("温馨提示2：您在【\(isInWidget ? "在桌面": "在app里")】点击了背景)")
                    onTap()
                }, label: {
                    Text("")
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .background(Color.clear)
                        .foregroundColor(.clear)
                        .cornerRadius(5)
                }).frame(width: geometry.size.width,height: geometry.size.height)
            })
        }
    }
    
    var currentPageType: CQPageType {
        if let pageInfo = pageInfo {
            return pageInfo.pageType
        }
        return .unknown
    }
    
    var currentPageAppearType: CQPageAppearType {
        if let pageInfo = pageInfo {
            return pageInfo.appearType
        }
        return .unknown
    }
}
