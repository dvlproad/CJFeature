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
    
    @State private var isAdReady: Bool = false
    private let adManager = AdManager()
    @State private var yourAdManager: YourAdManager
    
    @State private var showAd = false
        @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("穿山甲广告 Demo")
                .font(.title)
                .padding()
            
            Button("加载Feed广告") {
                let viewModel = YourViewModel(slotID: "your_ad_slot_id") // 替换为feed广告位 ID
                yourAdManager = YourAdManager(viewModel: viewModel)
            }
            .buttonStyle(.borderedProminent)
            
            Button("加载激励广告") {
                adManager.loadRewardedAd(adSlotID: "your_ad_slot_id") // 替换为激励视频广告位 ID
            }
            .buttonStyle(.borderedProminent)
            
            if isAdReady {
                Button("展示激励广告") {
                    showAd.toggle()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("广告未加载")
                    .foregroundColor(.gray)
            }
            
            if let errorMessage = errorMessage {
                Text("错误: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .adReadyNotification)) { notification in
            if let userInfo = notification.userInfo, let isReady = userInfo["isReady"] as? Bool {
                self.isAdReady = isReady
            }
        }
        .sheet(isPresented: $showAd) {
                    RewardedAdView(adManager: adManager)
                }
        
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
    
    // MARK: - Notification Observers
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name.adReadyNotification, object: nil, queue: .main) { notification in
            if let error = notification.object as? Error {
                let errorMessage = error.localizedDescription
                debugPrint("激励视频广告加载失败: \(errorMessage)")
                return
            }
            
            if let userInfo = notification.userInfo {
                isAdReady = userInfo["isReady"] as? Bool ?? false
                debugPrint("激励视频广告加载状态: \(isAdReady)")
            }
        }
    }
    
    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.adReadyNotification, object: nil)
    }
}
