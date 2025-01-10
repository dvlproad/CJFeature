//
//  CJPageInfo.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2024/12/23.
//

import Foundation

enum CQPageType: String {
    case unknown            // 未知页面
    case homePage           // 在首页
    case widgetDetailPage   // 在组件详情页面
    case widgetEditPge      // 在组件编辑页面
    case myWidgetPage       // 在我的组件页面
    case searchResultPage   // 在组件搜索页面
    case imageEditPage      // 图片编辑页面
    case inDesktop          // 在桌面
}

enum CQPageAppearType: String {
    case unknown = "unknown"
    case firstAppear = "firstAppear"    // 此页面第一次显示，相当于 viewDidload
    case reAppear = "reAppear"          // 此页面再次显示
}

struct CQPageInfo {
    var pageType: CQPageType = .unknown // 是否是在详情页面中，目前仅锁屏中的签名在使用
    var appearType: CQPageAppearType = .unknown
    var fromPageType: CQPageType = .unknown
}

