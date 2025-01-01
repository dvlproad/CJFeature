//
//  CJAdConfigModel.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation


// 广告位状态
enum AdState: Int {
    case close = 0
    case open = 1
}

//壁纸、组件、动画岛
enum AdUnlockType: String {
    case Widget
    case Wallpaper
    case AnimationIsland
    case OpenScreen
    case HalfScreen /// 插半屏
    case SearchResultsBanner /// Banner广告
    case homeFeed
    case wallpaperFeed

}

class AdConfigModel {
    var type: String?       // 1 插屏广告 2 激励视频 3 开屏广告
    var adId: String?       // 广告id
    var optState: AdState?
    var adArgument: String? // 广告位
    
    
    init(type: String?, adId: String?, optState: AdState? = nil, adArgument: String?) {
        self.type = type
        self.adId = adId
        self.optState = optState
        self.adArgument = adArgument
    }
}
