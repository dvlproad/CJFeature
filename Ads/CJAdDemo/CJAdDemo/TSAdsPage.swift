//
//  TSAdsPage.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import SwiftUI

class TSDataModel {
    var title: String = ""
    var isAdBannerModel: Bool = false
    var adIndex: Int = -1
    
    var adViewHeight: CGFloat = feedAdPlaceholderHeight
    var isReloadToUpdateAdViewHeight: Bool = false
    
    init(title: String) {
        self.isAdBannerModel = false
        self.title = title
    }
    
    init(adIndex: Int) {
        self.isAdBannerModel = true
        self.adIndex = adIndex
    }
}

struct TSAdsPage: View {
    let adModels = [
        AdConfigModel(type: "2", adId: "102894507", adArgument: "AnimationIsland"),
        AdConfigModel(type: "2", adId: "102894507", adArgument: "Widget"),
        AdConfigModel(type: "1", adId: "102917460", adArgument: "Wallpaper"),
        AdConfigModel(type: "3", adId: "102997187", adArgument: "OpenScreen"),
        AdConfigModel(type: "4", adId: "102996254", adArgument: "HalfScreen"),
        AdConfigModel(type: "4", adId: "103161544", adArgument: "SearchResultsBanner"),
        AdConfigModel(type: "5", adId: "103303563", adArgument: AdUnlockType.homeFeed.rawValue),
        AdConfigModel(type: "5", adId: "103303645", adArgument: AdUnlockType.wallpaperFeed.rawValue),
    ]
    
    @State private var isAdReady: Bool = false
    private let adManager = AdManager()
    @State private var yourAdManager: YourAdManager?
    
    @State private var showAd = false
        @State private var errorMessage: String?
    
    
    @State var model: TSDataModel = TSDataModel(title: "1")
    
//    var adView: CCAdView?
    
    var body: some View {
        /*
        VStack {
            Text("穿山甲广告 Demo")
                .font(.title)
                .padding()
            
            Button("加载Feed广告") {
                let viewModel = YourViewModel(slotID: "103303563") // 替换为feed广告位 ID
                yourAdManager = YourAdManager(viewModel: viewModel)
            }
            .buttonStyle(.borderedProminent)
            
            Button("加载激励广告") {
                adManager.loadRewardedAd(adSlotID: "103161544") // 替换为激励视频广告位 ID
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
        */
        
        
        WidthAdCollectionViewWrapper()
        
        VStack(alignment: .center) {
            let bannerAdModel = AdConfigModel(type: "4", adId: "103320730", adArgument: "SearchResultsBanner")
            
            let adView = CCAdView(
                adConfigModel: bannerAdModel,
                adWidth: screenWidth-2*12,
                currentAdViewHeight: model.adViewHeight,
                adViewHeightChangeBlock: { newAdViewHeight in
//                    model.adViewHeight = newAdViewHeight
//                    adViewHeightChangeBlock(newAdViewHeight)
                },
                isReloadToUpdateAdViewHeight: model.isReloadToUpdateAdViewHeight
            )
            
            adView
//            AdvertiseBannerRepresentable(
//                adConfigModel: bannerAdModel,
//                adSize: CGSize(width: 338, height: 84)
//            )
//            .frame(width: screenWidth, height: 211)
        }
        .background(Color.white)
        
        
        VStack(alignment: .center) {
            let bannerAdModel = AdConfigModel(type: "4", adId: "103161544", adArgument: "SearchResultsBanner")
            CCFeedAdDocumViewVCepresentable(
                adConfigModel: bannerAdModel,
                adWidth: 338,
                adPlaceholderHeight: 84,
                placeholder: true,
                nativeExpressAdLoad: { _ in },
                nativeExpressAdViewRender: { _,_ in },
                isReloadToUpdateAdViewHeight: false
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
