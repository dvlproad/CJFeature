//
//  CCFeedAdDocumView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/3.
//
//  https://www.csjplatform.com/union/media/union/download/detail?id=197&docId=27496&locale=zh-CN&osType=ios

import Foundation
import BUAdSDK
import SwiftUI



/// feed广告view
struct CCFeedAdDocumViewVCepresentable: UIViewControllerRepresentable {
    var adConfigModel: AdConfigModel
    var adWidth: CGFloat                // 广告不管显示不显示固定的宽度
    var adPlaceholderHeight: CGFloat    // 未显示时候用来占位的高度
    var placeholder: Bool
    var nativeExpressAdLoad: ((_ isSuccess: Bool) -> Void)
    var nativeExpressAdViewRender: ((_ isSuccess: Bool, _ adFrame: CGRect) -> Void)
    var isReloadToUpdateAdViewHeight: Bool
    
    // 定义UIViewController类型
    typealias UIViewControllerType = CCFeedAdDocumViewVC
    
    var vc: CCFeedAdDocumViewVC?
    
    // 创建并返回一个新的UIViewController
    func makeUIViewController(context: Context) -> CCFeedAdDocumViewVC {
        // 创建并返回UIViewController
        let vc = CCFeedAdDocumViewVC(adConfigModel: adConfigModel, adWidth: adWidth, adPlaceholderHeight: adPlaceholderHeight, placeholder: placeholder, nativeExpressAdLoad: nativeExpressAdLoad, nativeExpressAdViewRender: nativeExpressAdViewRender, isReloadToUpdateAdViewHeight: isReloadToUpdateAdViewHeight)
        return vc
    }
    
    // 更新UIViewController，如果需要的话
    func updateUIViewController(_ uiViewController: CCFeedAdDocumViewVC, context: Context) {
        // 可以在这里对UIViewController进行任何更新
        
    }
}

class CCFeedAdDocumViewVC: UIViewController, BUNativeAdsManagerDelegate, BUNativeAdDelegate {
    var adConfigModel: AdConfigModel
    var adWidth: CGFloat                // 广告不管显示不显示固定的宽度
    var adPlaceholderHeight: CGFloat    // 未显示时候用来占位的高度
    var placeholder: Bool
    var nativeExpressAdLoad: ((_ isSuccess: Bool) -> Void)
    var isReloadToUpdateAdViewHeight: Bool
    var nativeExpressAdViewRender: ((_ isSuccess: Bool, _ adFrame: CGRect) -> Void)
    
    init(adConfigModel: AdConfigModel,
         adWidth: CGFloat, adPlaceholderHeight: CGFloat, placeholder: Bool,
         nativeExpressAdLoad: @escaping (_ isSuccess: Bool) -> Void,
         nativeExpressAdViewRender: @escaping (_ isSuccess: Bool, _ adFrame: CGRect) -> Void,
         isReloadToUpdateAdViewHeight: Bool
    ) {
        self.adConfigModel = adConfigModel
        self.adWidth = adWidth
        self.adPlaceholderHeight = adPlaceholderHeight
        self.placeholder = placeholder
        self.nativeExpressAdLoad = nativeExpressAdLoad
        self.nativeExpressAdViewRender = nativeExpressAdViewRender
        self.isReloadToUpdateAdViewHeight = isReloadToUpdateAdViewHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        adConfigModel = AdConfigModel(type: "5", adId: "103303563", adArgument: AdUnlockType.homeFeed.rawValue)
        adWidth = screenWidth
        adPlaceholderHeight = 211
        placeholder = false
        nativeExpressAdLoad = { _ in }
        nativeExpressAdViewRender = { _,_ in }
        isReloadToUpdateAdViewHeight = false
        super.init(coder: coder)
    }
    
    var imageView: UIImageView?
    override func viewDidLoad() {
//        addAdView()
        p_buildAd()
        p_loadAdData()
        
        if placeholder {
            self.view.backgroundColor = UIColor.red
            let imageView: UIImageView = UIImageView()
            //imageView.backgroundColor = .red
            imageView.image = UIImage(named: "placeholder_ad")
            imageView.contentMode = .scaleAspectFill
            self.view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 42, height: 42))
                make.center.equalToSuperview()
            }
            self.imageView = imageView
        }
    }
    

    
    let gromore_feed_ID: String = "103320730"// "103303563"
    var adManager: BUNativeAdsManager?
    
    // 创建广告对象
    func p_buildAd() {
        let slot1 = BUAdSlot()
        let imgSize1 = BUSize()
        imgSize1.width = 1080
        imgSize1.height = 1920 // 按照实际情况设置宽高
        slot1.imgSize = imgSize1
        
        slot1.id = gromore_feed_ID // 聚合维度通过广告位ID发起请求，仅接入CSJ广告通过代码位ID发起请求
        
        // 聚合维度：如果是模板广告，返回高度将不一定是300，而是按照414和对应代码位在平台的配置计算出的高度
        slot1.adSize = CGSize(width: UIScreen.main.bounds.size.width, height: 400)
//        slot1.adType = .feed
//        slot1.position = .feed
        
        slot1.mediation.mutedIfCan = true // 是否静音
        
        let adManager: BUNativeAdsManager = BUNativeAdsManager(slot: slot1)
        adManager.mediation?.rootViewController = self
        adManager.delegate = self
        self.adManager = adManager
    }

    // 触发广告加载
    func p_loadAdData() {
        self.adManager?.loadAdData(withCount: 3) // 加载广告数量，支持设置1-3个
    }

    // 收到load成功回调后展示
    // BUMNativeAdsManagerDelegate
    func nativeAdsManagerSuccess(toLoad adsManager: BUNativeAdsManager, nativeAds nativeAdDataArray: [BUNativeAd]?) {
        guard let nativeAdDataArray = nativeAdDataArray else { return }

        for model in nativeAdDataArray {
//            let index = Int.random(in: 2..<self.dataSource.count - 1)

            model.rootViewController = self
            model.delegate = self
            if let mediation = model.mediation, mediation.isExpressAd {
                mediation.render()
            }
//            self.dataSource.insert(model, at: index)
        }
        
//        self.tableView.reloadData()
    }

    // 广告加载失败
    func nativeAdsManager(_ adsManager: BUNativeAdsManager, didFailWithError error: Error?) {
        debugPrint("nativeAdsManager:didFailWithError:\(error?.cjErrorString ?? "未知错误")")
    }
    /******** 信息流广告展示回调处理 *********/
    // MARK: - BUMNativeAdDelegate

    // 广告视图展示
    func nativeAdDidBecomeVisible(_ nativeAd: BUNativeAd) {
        debugPrint("nativeAdDidBecomeVisible")
    }

    // 广告被点击
    func nativeAdDidClick(_ nativeAd: BUNativeAd, with view: UIView?) {
        debugPrint("nativeAdDidClick")
    }

    // 广告渲染成功，仅模板广告会回调
    func nativeAdExpressViewRenderSuccess(_ nativeAd: BUNativeAd)  {
        // 渲染后广告视图的尺寸可能调整，可以在此刷新UI
        debugPrint("nativeAdExpressViewRenderSuccess")
    }

    // 广告渲染失败
    func nativeAdExpressViewRenderFail(_ nativeAd: BUNativeAd, error: Error?) {
        debugPrint("nativeAdExpressViewRenderFail")
    }

    // 负反馈
    func nativeAd(_ nativeAd: BUNativeAd?, dislikeWithReason filterWords: [BUDislikeWords]?) {
        // 需手动移除视图
        debugPrint("nativeAdDislikeWithReason:\(filterWords ?? [])")
    }

    // 视频播放状态变更
    func nativeAdVideo(_ nativeAd: BUNativeAd?, stateDidChanged playerState: BUPlayerPlayState) {
        debugPrint("nativeAdVideo:stateDidChanged:\(playerState)")
    }

    // 视频播放完成
    func nativeAdVideoDidPlayFinish(_ nativeAd: BUNativeAd?) {
        debugPrint("nativeAdVideoDidPlayFinish")
    }

    // 即将展示详情页
    func nativeAdWillPresentFullScreenModal(_ nativeAd: BUNativeAd) {
        debugPrint("nativeAdWillPresentFullScreenModal")
    }

    // 视频被点击
    func nativeAdVideoDidClick(_ nativeAd: BUNativeAd?) {
        debugPrint("nativeAdVideoDidClick")
    }

    // 广告摇一摇提示view消除
    func nativeAdShakeViewDidDismiss(_ nativeAd: BUNativeAd?) {
        debugPrint("nativeAdShakeViewDidDismiss")
    }

    // 激励信息流视频进入倒计时状态
    func nativeAdVideo(_ nativeAdView: BUNativeAd?, rewardDidCountDown countDown: Int) {
        debugPrint("nativeAdVideo:rewardDidCountDown:\(countDown)")
    }
}
