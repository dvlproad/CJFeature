//
//  CJAdBannerView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import SwiftUI
import BUAdSDK

let screenWidth = UIScreen.main.bounds.width
let feedAdPlaceholderHeight: CGFloat = 84
func feedAdSize() -> CGSize {
    return  CGSizeMake(screenWidth, 84+2*10)    // 广告流的大小
}


///banner广告view
struct AdvertiseBannerRepresentable: UIViewControllerRepresentable {
    var adConfigModel: AdConfigModel
    var adSize: CGSize
    
    // 定义UIViewController类型
    typealias UIViewControllerType = AdvertiseBannerVC
    
    
    // 创建并返回一个新的UIViewController
    func makeUIViewController(context: Context) -> AdvertiseBannerVC {
        // 创建并返回UIViewController
        return AdvertiseBannerVC(adConfigModel: adConfigModel, adSize: adSize)
    }
    
    // 更新UIViewController，如果需要的话
    func updateUIViewController(_ uiViewController: AdvertiseBannerVC, context: Context) {
        // 可以在这里对UIViewController进行任何更新
        
    }
}
class AdvertiseBannerVC: UIViewController, BUNativeExpressBannerViewDelegate {
    var adConfigModel: AdConfigModel
    var adSize: CGSize
    var  bannerView:BUNativeExpressBannerView?
    
    init(adConfigModel: AdConfigModel, adSize: CGSize, bannerView: BUNativeExpressBannerView? = nil) {
        self.adConfigModel = adConfigModel
        self.adSize = adSize
        self.bannerView = bannerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        adConfigModel = AdConfigModel(type: "4", adId: "103161544", adArgument: "SearchResultsBanner")
        adSize = CGSizeMake(screenWidth, 211)
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        loadBannerAd()
    }
    /******** Banner广告配置 *********/
    func loadBannerAd() -> Void {
        // 先去除上次展示的广告
        if self.bannerView != nil{
            self.bannerView?.removeFromSuperview()
        }
//        let adModel = AdvertiseManager.shared.getAdConfigModel(adArgument: "SearchResultsBanner")
        let adModel = adConfigModel
        // 重新配置广告并加载
//        let adSize = CGSizeMake(screenWidth, 211)
        let slot = BUAdSlot()
        if let adId = adModel.adId{
            slot.id = adId
        }else{
            slot.id = "103161544"
        }
        self.bannerView = BUNativeExpressBannerView(slot: slot, rootViewController: self, adSize: adSize)
        self.bannerView?.frame = CGRect(x: 0, y: 0, width: adSize.width, height: adSize.height)
        self.bannerView?.delegate = self
        self.bannerView?.loadAdData()
    }

    /******** Banner广告回调处理 *********/
    // MARK: - BUMNativeExpressBannerViewDelegate
    /**
     This method is called when bannerAdView ad slot loaded successfully.
     @param bannerAdView : view for bannerAdView
     */
    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewDidLoad")
        // 广告加载成功之后，可以调用展示方法，按照实际需要调整代码位置
        self.view.addSubview(bannerAdView)
    }
    

    /**
     This method is called when bannerAdView ad slot failed to load.
     @param error : the reason of error
     */
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewDidLoadFailWithError:\(error?.cjErrorString ?? "未知错误")")
    }
    
    /**
     This method is called when rendering a nativeExpressAdView successed.
     */
    // Mediation:/// @Note :  (针对聚合维度广告)<6400版本不会回调该方法，>=6400开始会回调该方法，但不代表最终展示广告的渲染结果。
    func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewRenderSuccess")
    }

    /**
     This method is called when a nativeExpressAdView failed to render.
     @param error : the reason of error
     */
    // Mediation:/// @Note :  (针对聚合维度广告)<6400版本不会回调该方法，>=6400开始会回调该方法，但不代表最终展示广告的渲染结果。
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewRenderFail")
    }
    
    /**
     This method is called when bannerAdView ad slot showed new ad.
    // Mediation:@Note :  Mediation dimension does not support this callBack.
     */
    func nativeExpressBannerAdViewWillBecomVisible(_ bannerAdView: BUNativeExpressBannerView) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewWillBecomVisible")
    }
    
    /**
     This method is called when bannerAdView is clicked.
     */
    func nativeExpressBannerAdViewDidClick(_ bannerAdView: BUNativeExpressBannerView) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewDidClick")
    }

    /**
     This method is called when the user clicked dislike button and chose dislike reasons.
     @param filterwords : the array of reasons for dislike.
     */
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, dislikeWithReason filterwords: [BUDislikeWords]?) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewDislikeWithReason")
    }

    /**
     This method is called when another controller has been closed.
     @param interactionType : open appstore in app or open the webpage or view video ad details page.
     */
    func nativeExpressBannerAdViewDidCloseOtherController(_ bannerAdView: BUNativeExpressBannerView, interactionType: BUInteractionType) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewDidCloseOtherController:interactionType:\(interactionType)")
    }

    /**
     This method is called when the Ad view container is forced to be removed.
     @param bannerAdView : Express Banner Ad view container
     */
    func nativeExpressBannerAdViewDidRemoved(_ bannerAdView: BUNativeExpressBannerView) {
        debugPrint("===AdBanner===nativeExpressBannerAdViewDidRemoved")
    }
}
