//
//  CJRewardedAdManager.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import BUAdSDK
import SwiftUI

extension Notification.Name {
    static let adReadyNotification = Notification.Name("AdReadyNotification")
}


struct RewardedAdView: UIViewControllerRepresentable {
    let adManager: AdManager

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            adManager.showRewardedAd(from: viewController)
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


class AdManager: NSObject, BUNativeExpressRewardedVideoAdDelegate {
    private var rewardedAd: BUNativeExpressRewardedVideoAd?
    
    
    /// 加载激励广告
    func loadRewardedAd(adSlotID: String) {
        let rewardedAd = BUNativeExpressRewardedVideoAd(slotID: adSlotID, rewardedVideoModel: BURewardedVideoModel())
        rewardedAd.delegate = self
        rewardedAd.loadData()
        self.rewardedAd = rewardedAd
        
        
    }
    
    /// 展示激励广告
    func showRewardedAd(from viewController: UIViewController) {
        guard let rewardedAd = rewardedAd, isAdReady else {
            print("广告未准备好")
            return
        }
        rewardedAd.show(fromRootViewController: viewController)
    }
    

    // MARK: - BUNativeExpressRewardedVideoAdDelegate
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print("激励视频广告加载成功")
        updateAdState(isAdReady: true)
    }

    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        print("激励视频广告加载失败: \(error?.cjErrorString ?? "未知错误")")
        updateAdState(isAdReady: false)
    }

    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        print("激励视频广告关闭")
        updateAdState(isAdReady: false) // 关闭广告后重置状态
    }
    
    // MARK: - Private
    private var isAdReady: Bool = false // 标志广告是否已准备好
    private func updateAdState(isAdReady: Bool) {
        self.isAdReady = isAdReady
        NotificationCenter.default.post(name: .adReadyNotification, object: nil, userInfo: ["isReady": isAdReady])
    }
}
