//
//  TSAdsPage.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import SwiftUI

struct TSAdsPage: View {
    let adModels = [
        AdConfigModel(type: "2", adId: "广告id", adArgument: "AnimationIsland"),
        AdConfigModel(type: "2", adId: "首页广告id", adArgument: "Widget"),
        AdConfigModel(type: "1", adId: "壁纸广告id", adArgument: "Wallpaper"),
        AdConfigModel(type: "3", adId: "开屏广告id", adArgument: "OpenScreen"),
        AdConfigModel(type: "4", adId: "半屏广告id", adArgument: "HalfScreen"),
        AdConfigModel(type: "4", adId: "banner广告Id", adArgument: "SearchResultsBanner"),
        AdConfigModel(type: "5", adId: "首页广告流Id", adArgument: AdUnlockType.homeFeed.rawValue),
        AdConfigModel(type: "5", adId: "壁纸广告流Id", adArgument: AdUnlockType.wallpaperFeed.rawValue),
    ]
    
    var body: some View {
        VStack(alignment: .center) {
            let bannerAdModel = AdConfigModel(type: "4", adId: "banner广告Id", adArgument: "SearchResultsBanner")
            CCAdView(
                adConfigModel: AdConfigModel(
                    type: "5",
                    adId: "首页广告流Id",
                    adArgument: AdUnlockType.homeFeed.rawValue
                ),
                adSize: feedAdSize()
            )
            AdvertiseBannerRepresentable(
                adConfigModel: bannerAdModel,
                adSize: CGSize(width: 338, height: 84)
            )
            .frame(width: screenWidth, height: 211)
        }
        .background(Color.white)
    }
}
