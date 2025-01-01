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

///banner广告view
struct CCAdvertiseViewRepresentable: UIViewControllerRepresentable {
    var adConfigModel: AdConfigModel
    var adSize: CGSize
    var placeholder: Bool
    var nativeExpressAdSuccess: (() -> Void)
    
    // 定义UIViewController类型
    typealias UIViewControllerType = CCAdvertiseViewVC
    
    
    // 创建并返回一个新的UIViewController
    func makeUIViewController(context: Context) -> CCAdvertiseViewVC {
        // 创建并返回UIViewController
        return CCAdvertiseViewVC(adConfigModel: adConfigModel, adSize: adSize, placeholder: placeholder, nativeExpressAdSuccess: nativeExpressAdSuccess)
    }
    
    // 更新UIViewController，如果需要的话
    func updateUIViewController(_ uiViewController: CCAdvertiseViewVC, context: Context) {
        // 可以在这里对UIViewController进行任何更新
        
    }
}


class CCAdvertiseViewVC: UIViewController, BUNativeExpressAdViewDelegate {
    var adConfigModel: AdConfigModel
    var adSize: CGSize
    var placeholder: Bool
    var nativeExpressAdSuccess: (() -> Void)
    
    init(adConfigModel: AdConfigModel, adSize: CGSize, placeholder: Bool, nativeExpressAdSuccess: @escaping () -> Void) {
        self.adConfigModel = adConfigModel
        self.adSize = adSize
        self.placeholder = placeholder
        self.nativeExpressAdSuccess = nativeExpressAdSuccess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        adConfigModel = AdConfigModel(type: "5", adId: "广告流Id", adArgument: AdUnlockType.homeFeed.rawValue)
        adSize = CGSizeMake(screenWidth, 211)
        placeholder = false
        nativeExpressAdSuccess = {}
        super.init(coder: coder)
    }
    
    var imageView: UIImageView?
    override func viewDidLoad() {
        addAdView()
        
        if placeholder {
            self.view.backgroundColor = UIColor.lightGray
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
        slot1.id = adConfigModel.adId ?? "广告流Id"
        slot1.adType = .feed
        slot1.imgSize = BUSize(by: BUProposalSize.feed228_150)
        slot1.position = .feed

        // self.nativeExpressAdManager 可以重用
        if self.nativeExpressAdManager == nil {
            self.nativeExpressAdManager = BUNativeExpressAdManager(slot: slot1, adSize: self.adSize)
        }
        self.nativeExpressAdManager?.adSize = self.adSize
        self.nativeExpressAdManager?.delegate = self
        self.nativeExpressAdManager?.loadAdData(withCount: 1)
    }
    

//    展示时机
//    在收到nativeExpressAdSuccessToLoad回调后再进行广告的渲染展示，刷新数据源
    /**
     * Sent when views successfully load ad
     */
    func nativeExpressAdSuccess(toLoad nativeExpressAdManager: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
        debugPrint("===AdFeed===nativeExpressAdSuccessToLoad")
        
        // 【重要】不能保存太多view，需要在合适的时机手动释放不用的，否则内存会过大
        self.expressAdViews.removeAll()

        if views.count > 0 {
            self.expressAdViews.append(contentsOf: views)
            for (_, obj) in views.enumerated() {
                let expressView: BUNativeExpressAdView = obj
                expressView.rootViewController = self
                // important: 此处会进行WKWebview的渲染，建议一次最多预加载三个广告，如果超过3个会很大概率导致WKWebview渲染失败。
                expressView.render()
            }
        }

//        self.tableView.reloadData()
        nativeExpressAdSuccess()
        
       
        self.imageView?.removeFromSuperview()
    }
    

    /**
     * Sent when views fail to load ad
     */
    func nativeExpressAdFail(toLoad nativeExpressAdManager: BUNativeExpressAdManager, error: Error?) {
        debugPrint("===AdFeed===nativeExpressAdFailToLoad:\(error.debugDescription)")
    }
    
    ///**
    // * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updated
    // */
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: BUNativeExpressAdView) {
        debugPrint("===AdFeed===nativeExpressAdViewRenderSuccess")
    }
    
    ///**
    // * This method is called when a nativeExpressAdView failed to render
    // */
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        debugPrint("===AdFeed===nativeExpressAdViewRenderFail:\(error.debugDescription)")
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
