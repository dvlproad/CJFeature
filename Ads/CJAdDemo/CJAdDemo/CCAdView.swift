//
//  CCAdView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import BUAdSDK
import SwiftUI
import SnapKit

/// feed广告view
struct CCAdvertiseViewRepresentable: UIViewControllerRepresentable {
    var adConfigModel: AdConfigModel
    var adWidth: CGFloat                // 广告不管显示不显示固定的宽度
    var adPlaceholderHeight: CGFloat    // 未显示时候用来占位的高度
    var placeholder: Bool
    var nativeExpressAdLoad: ((_ isSuccess: Bool) -> Void)
    var nativeExpressAdViewRender: ((_ isSuccess: Bool, _ adFrame: CGRect) -> Void)
    var isReloadToUpdateAdViewHeight: Bool
    
    // 定义UIViewController类型
    typealias UIViewControllerType = CCAdvertiseViewVC
    
    var vc: CCAdvertiseViewVC?
    
    // 创建并返回一个新的UIViewController
    func makeUIViewController(context: Context) -> CCAdvertiseViewVC {
        // 创建并返回UIViewController
        //let uiViewController = CCAdvertiseViewVC(adConfigModel: adConfigModel, adWidth: adWidth, adPlaceholderHeight: adPlaceholderHeight, placeholder: placeholder, nativeExpressAdLoad: nativeExpressAdLoad, nativeExpressAdViewRender: nativeExpressAdViewRender, isReloadToUpdateAdViewHeight: isReloadToUpdateAdViewHeight)
        let uiViewController = CCAdvertiseViewVC()
        uiViewController.update(adConfigModel: adConfigModel, adWidth: adWidth, adPlaceholderHeight: adPlaceholderHeight, placeholder: placeholder, nativeExpressAdLoad: nativeExpressAdLoad, nativeExpressAdViewRender: nativeExpressAdViewRender, isReloadToUpdateAdViewHeight: isReloadToUpdateAdViewHeight)
        return uiViewController
    }
    
    // 更新UIViewController，如果需要的话
    func updateUIViewController(_ uiViewController: CCAdvertiseViewVC, context: Context) {
        // 可以在这里对UIViewController进行任何更新
        //uiViewController.update(adConfigModel: adConfigModel, adWidth: adWidth, adPlaceholderHeight: adPlaceholderHeight, placeholder: placeholder, nativeExpressAdLoad: nativeExpressAdLoad, nativeExpressAdViewRender: nativeExpressAdViewRender, isReloadToUpdateAdViewHeight: isReloadToUpdateAdViewHeight)
        
    }
}

class CCAdvertiseViewVC: UIViewController, BUNativeExpressAdViewDelegate {
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
    
    required init() {
        adConfigModel = AdConfigModel(type: "5", adId: "103320730", adArgument: AdUnlockType.homeFeed.rawValue)
        adWidth = screenWidth
        adPlaceholderHeight = 211
        placeholder = false
        nativeExpressAdLoad = { _ in }
        nativeExpressAdViewRender = { _,_ in }
        isReloadToUpdateAdViewHeight = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        adConfigModel = AdConfigModel(type: "5", adId: "103320730", adArgument: AdUnlockType.homeFeed.rawValue)
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
        addAdView()
        
        if placeholder {
            self.view.backgroundColor = UIColor.gray
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
    
    var nativeExpressAdManager: BUNativeExpressAdManager?
    var expressAdViews: [BUNativeExpressAdView] = []
    func addAdView() -> Void {
        let slot1 = BUAdSlot()
        slot1.id = adConfigModel.adId ?? "103320730"
        slot1.adType = .feed
        slot1.imgSize = BUSize(by: BUProposalSize.feed228_150)
        slot1.position = .feed

        // self.nativeExpressAdManager 可以重用
        if self.nativeExpressAdManager == nil {
            self.nativeExpressAdManager = BUNativeExpressAdManager(slot: slot1, adSize: CGSize(width: self.adWidth, height: 0))
        }
        self.nativeExpressAdManager?.adSize = CGSize(width: self.adWidth, height: 0)
        self.nativeExpressAdManager?.delegate = self
        if !isReloadToUpdateAdViewHeight {
            self.nativeExpressAdManager?.loadAdData(withCount: 1)
        }
    }
    
    func update(adConfigModel: AdConfigModel,
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
        
    }
    

//    展示时机
//    在收到nativeExpressAdSuccessToLoad回调后再进行广告的渲染展示，刷新数据源
//    - (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views;
    func nativeExpressAdSuccess(toLoad nativeExpressAdManager: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
        // 【重要】不能保存太多view，需要在合适的时机手动释放不用的，否则内存会过大
        self.expressAdViews.removeAll()
        
        for (_, obj) in self.expressAdViews.enumerated() {
            let expressView: BUNativeExpressAdView = obj
            expressView.removeFromSuperview()
        }

        if views.count > 0 {
            self.expressAdViews.append(contentsOf: views)
            for (_, obj) in views.enumerated() {
                let expressView: BUNativeExpressAdView = obj
                expressView.rootViewController = self
                // important: 此处会进行WKWebview的渲染，建议一次最多预加载三个广告，如果超过3个会很大概率导致WKWebview渲染失败。
                expressView.render()
            }
        }
        
        for (_, obj) in self.expressAdViews.enumerated() {
            let expressView: BUNativeExpressAdView = obj
            self.view.addSubview(expressView)
        }

//        self.tableView.reloadData()
        nativeExpressAdLoad(true)
        
       
        self.imageView?.removeFromSuperview()
        //eventReportedApi(eventCode: "feed_ad_show")
    }
    
    /**
     * Sent when views fail to load ad
     */
    func nativeExpressAdFail(toLoad nativeExpressAdManager: BUNativeExpressAdManager, error: Error?) {
        var adslotId: String = "nil"
        if let adslot = nativeExpressAdManager.adslot {
            adslotId = adslot.id
        }
        debugPrint("===AdFeed===nativeExpressAdFailToLoad:广告位\(adslotId) \(error?.cjErrorString ?? "未知错误")")
        nativeExpressAdLoad(false)
    }
    
    ///**
    // * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updated
    // */
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: BUNativeExpressAdView) {
        
        debugPrint("===AdFeed===nativeExpressAdViewRenderSuccess\(nativeExpressAdView.frame)")
        nativeExpressAdViewRender(true, nativeExpressAdView.frame)
    }
    
    ///**
    // * This method is called when a nativeExpressAdView failed to render
    // */
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        debugPrint("===AdFeed===nativeExpressAdViewRenderFail:\(error.debugDescription)")
        nativeExpressAdViewRender(false, nativeExpressAdView.frame)
    }
    
    ///**
    // * Sent when an ad view is about to present modal content
    // */
    func nativeExpressAdViewWillShow(_ nativeExpressAdView: BUNativeExpressAdView) {
        debugPrint("===AdFeed===nativeExpressAdViewWillShow")
    }
    
    
    ///**
    // * Sent when an ad view is clicked
    // */
    func nativeExpressAdViewDidClick(_ nativeExpressAdView: BUNativeExpressAdView) {
        debugPrint("===AdFeed===nativeExpressAdViewDidClick:")
    }
    
    
    ///**
    //Sent when a playerw playback status changed.
    //@param playerState : player state after changed
    //*/
    func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, stateDidChanged playerState: BUPlayerPlayState) {
        debugPrint("===AdFeed===nativeExpressAdView:\(playerState)")
    }
    
    ///**
    // * Sent when a player finished
    // * @param error : error of player
    // */
    func nativeExpressAdViewPlayerDidPlayFinish(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        debugPrint("===AdFeed===nativeExpressAdViewPlayerDidPlayFinish:\(error.debugDescription)")
    }
    
    
    ///**
    // * Sent when a user clicked dislike reasons.
    // * @param filterWords : the array of reasons why the user dislikes the ad
    // */
    func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, dislikeWithReason filterWords: [BUDislikeWords]) {
        debugPrint("===AdFeed===nativeExpressAdViewDislikeWithReason:\(filterWords)")
    }
    
    
    ///**
    // * Sent after an ad view is clicked, a ad landscape view will present modal content
    // */
    func nativeExpressAdViewWillPresentScreen(_ nativeExpressAdView: BUNativeExpressAdView) {
        debugPrint("===AdFeed===nativeExpressAdViewWillPresentScreen")
    }
    
    
    ///**
    // This method is called when another controller has been closed.
    // @param interactionType : open appstore in app or open the webpage or view video ad details page.
    // */
    func nativeExpressAdViewDidCloseOtherController(_ nativeExpressAdView: BUNativeExpressAdView, interactionType: BUInteractionType) {
        debugPrint("===AdFeed===nativeExpressAdViewDidCloseOtherController:interactionType:\(interactionType)")
    }
    
    
    //
    ///**
    // This method is called when the Ad view container is forced to be removed.
    // @param nativeExpressAdView : Ad view container
    // */
    func nativeExpressAdViewDidRemoved(_ nativeExpressAdView: BUNativeExpressAdView) {
        debugPrint("===AdFeed===nativeExpressAdViewDidRemoved")
    }
}
