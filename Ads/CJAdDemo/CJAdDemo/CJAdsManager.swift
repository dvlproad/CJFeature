//
//  CJAdsManager.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import BUAdSDK

public struct CJAdsManager {
    public static let shared: CJAdsManager = CJAdsManager()
    
    
    static func BUAdSDKReset(_ channel: String? = nil){
        // vip会员去除全部广告
        
        /******************** 初始化 ********************/
        let configuration = BUAdSDKConfiguration()
        configuration.appID = "设置APPID"
        configuration.debugLog = NSNumber(integerLiteral: 0)    // 0:close 1:open
        configuration.useMediation = true   // 是否使用聚合
        // 添加渠道
        if  let channel = channel {
            let userInfo = BUMUserInfoForSegment()
            userInfo.channel = channel
            configuration.mediation.userInfoForSegment = userInfo
        }
        
        
        
        BUAdSDKManager.start(asyncCompletionHandler:{ success, error in
            guard success else {
                debugPrint("❌Error:BUAdSDK初始化失败")
                return
            }
            
            let fullScreenAdSlot = BUAdSlot()
            fullScreenAdSlot.id = "全屏的广告id"
            let fullScreenAd = BUNativeExpressFullscreenVideoAd(slot: fullScreenAdSlot)
            
            let rewardedSlot = BUAdSlot()
            rewardedSlot.id = "广告id"
            let rewardedVideoModel = BURewardedVideoModel()
            let rewardedVideoAd = BUNativeExpressRewardedVideoAd(slot: rewardedSlot, rewardedVideoModel: rewardedVideoModel)
            
            let splashAdSlot = BUAdSlot()
            splashAdSlot.id = "广告id"
            let splashAd = BUSplashAd(slot: splashAdSlot, adSize: CGSize.zero)
            
            let halfScreenAdSlot = BUAdSlot()
            halfScreenAdSlot.id = "半屏的广告id"
            let halfScreenAd = BUNativeExpressFullscreenVideoAd(slot: halfScreenAdSlot)
            
            let array = [
                rewardedVideoAd,
                fullScreenAd,
                splashAd,
                halfScreenAd
            ]
            BUAdSDKManager.mediation.preloadAds(withInfos: array, andInterval: 2, andConcurrent: 2)
        })
    }
    
}
