//
//  CJAdDelegate.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/9.
//
//  广告

import Foundation
import BUAdSDK


open class CJAdInstance: NSObject, BUNativeExpressAdViewDelegate {
    var adId: String
    var adRootViewController: UIViewController
    var adMaxCacheCount: Int
    var adViewRenderSuccessBlock: ((_ loadAdModel: CCLoadAdModel) -> Void)
    var adViewRenderFailureBlock: (() -> Void)
    
    var expressAdModels: [CCLoadAdModel]
    var nativeExpressAdManager: BUNativeExpressAdManager?
    
    init(adId: String,
         adRootViewController: UIViewController,
         adMaxCacheCount: Int,
         adviewRenderSuccessBlock: @escaping (_ loadAdModel: CCLoadAdModel) -> Void,
         adviewRenderFailureBlock: @escaping () -> Void
    ) {
        self.adId = adId
        self.adRootViewController = adRootViewController
        self.adMaxCacheCount = adMaxCacheCount
        self.adViewRenderSuccessBlock = adviewRenderSuccessBlock
        self.adViewRenderFailureBlock = adviewRenderFailureBlock
        
        self.expressAdModels = []
    }
    
    public func updateAdId(_ adId: String) {
        self.adId = adId
    }
    
    
    /// 获取第几个广告的视图
    public func getAdviewAtAdIndex(_ adIndex: Int) -> UIView? {
        if adIndex >= 0, adIndex < self.expressAdModels.count {
            let model: CCLoadAdModel = self.expressAdModels[adIndex]
            return model.expressAdView
        } else {
            return nil
        }
    }
    
    // 该广告还未加载出来则尝试加载(内部会判断如果正加载中则不用重发加载请求)
    public func loadAdIndex(_ adIndex: Int, adWidth: CGFloat, indexPath: IndexPath) -> Void {
        let adFailureModels = self.expressAdModels.filter { $0.shouldReload() }
        let adFailureCount = adFailureModels.count
        if adFailureCount > 0 {
            let firstFailureModel = adFailureModels[0]
            self.loadAd(loadAdModel: firstFailureModel, adWidth: adWidth)
        }

        var lastLoadAdModel: CCLoadAdModel? // 最后要加载的广告（如果未加载和加载失败，才需要加载）
        let hasLoadAdCount = self.expressAdModels.count
        if adIndex < hasLoadAdCount {
            let targetLoadAdModel = self.expressAdModels[adIndex]    // 当前位置的广告
            if targetLoadAdModel.loadState == .loadedFailure || targetLoadAdModel.loadState == .renderFailure {
                lastLoadAdModel = targetLoadAdModel
            }
        } else {
            let newLoadAdModel = CCLoadAdModel(indexPath: indexPath, index: adIndex) // 当前位置的广告
            self.expressAdModels.append(newLoadAdModel)

            lastLoadAdModel = newLoadAdModel
        }

        /*
         if adForModel.adLoadFinish {
         return
         }

         //let isExsit = self.adForModels.contains { $0.id == adForModel.id }
         let isExsit = self.adForModels.contains { $0.id == adForModel.id }
         if isExsit {
         return
         }
         self.adForModels.append(adForModel)
         */
        //        self.adForModels = [adForModel]

        if lastLoadAdModel != nil {
            loadAd(loadAdModel: lastLoadAdModel!, adWidth: adWidth)
        }
    }


    private func loadAd(loadAdModel: CCLoadAdModel, adWidth: CGFloat) {
        self.removeOverdueByCurrentLoadAdModel(loadAdModel)

        let slot1 = BUAdSlot()
        slot1.id = self.adId
        slot1.adType = .feed
        slot1.imgSize = BUSize(by: BUProposalSize.feed228_150)
        slot1.position = .feed

        // self.nativeExpressAdManager 可以重用
//        if self.nativeExpressAdManager == nil { // 使用此行，提示 40048 广告对象不可重复使用
        loadAdModel.nativeExpressAdManager = BUNativeExpressAdManager(slot: slot1, adSize: CGSize(width: adWidth, height: 0))
//        }
        loadAdModel.nativeExpressAdManager?.adSize = CGSize(width: adWidth, height: 0)
        loadAdModel.nativeExpressAdManager?.delegate = self
//        if !isReloadToUpdateAdViewHeight {
        loadAdModel.changeToLoadingState()
        loadAdModel.nativeExpressAdManager?.loadAdData(withCount: 1)
//        }
    }

    private func removeOverdueByCurrentLoadAdModel(_ loadAdModel: CCLoadAdModel) {
        CCLogUtil.log("正在加载第\(loadAdModel.index)个广告")
        // TODO: 目前发现 adMaxCacheCount 为 10 时候，进入页面，稍微往下滑时候就加载到第5个广告，实际页面上看才第3个，导致接收到时第5个，从而把第0个的广告给删除了。简而言之，现在加载第几个广告不准。会导致除了此问题外，还会造成广告加载时长不准
        let maxCacheCount = self.adMaxCacheCount
        let preRemoveIndex = loadAdModel.index - maxCacheCount/2
        if preRemoveIndex >= 0 {
            let removeLoadAdModel = self.expressAdModels[preRemoveIndex]
            self.removeLoadAdModel(removeLoadAdModel)
        }
        let tailRemoveIndex = loadAdModel.index + maxCacheCount/2
        if tailRemoveIndex < self.expressAdModels.count {
            let removeLoadAdModel = self.expressAdModels[tailRemoveIndex]
            self.removeLoadAdModel(removeLoadAdModel)
        }
    }

    private func removeLoadAdModel(_ loadAdModel: CCLoadAdModel) {
        if let expressAdView = loadAdModel.expressAdView {
            expressAdView.removeFromSuperview()
            loadAdModel.loadState = .unknown
            loadAdModel.expressAdView = nil
            loadAdModel.nativeExpressAdManager?.mediation?.destory()
            loadAdModel.nativeExpressAdManager = nil
        }
    }
    
    // MARK: BUNativeExpressAdViewDelegate
    public func nativeExpressAdSuccess(toLoad nativeExpressAdManager: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
        // 【重要】不能保存太多view，需要在合适的时机手动释放不用的，否则内存会过大
//        self.expressAdViews.removeAll()

        if views.count > 0 {
            //self.expressAdViews.append(contentsOf: views)
            for (_, obj) in views.enumerated() {
                let expressView: BUNativeExpressAdView = obj
                expressView.rootViewController = self.adRootViewController
                // important: 此处会进行WKWebview的渲染，建议一次最多预加载三个广告，如果超过3个会很大概率导致WKWebview渲染失败。
                expressView.render()
                //CCLogUtil.log("===AdFeed===LoadSuccess时候的高度: \(expressView.frame)")

                /*
                let adHeight = expressView.frame.size.height
                let expressAdModel = CCExpressAdModel(expressAdView: expressView, adViewHeight: adHeight)
                self.expressAdModels.append(expressAdModel)
                */
            }
        }


//        self.tableView.reloadData()
//        nativeExpressAdLoad(true)
//        self.collectionView.reloadData()
    }

    /**
     * Sent when views fail to load ad
     */
    public func nativeExpressAdFail(toLoad nativeExpressAdManager: BUNativeExpressAdManager, error: Error?) {
        var adslotId: String = "nil"
        if let adslot = nativeExpressAdManager.adslot {
            adslotId = adslot.id
        }
        logPrint("===AdFeed===nativeExpressAdFailToLoad:广告位\(adslotId) \(error?.cjErrorString ?? "未知错误")")
        CCLogUtil.log("ad load失败")
        //nativeExpressAdLoad(false)
        let adModel = self.expressAdModels.first { $0.expressAdView == nil }
        if let adModel = adModel {
            adModel.loadState = .loadedFailure
        }
    }

    ///**
    // * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updated
    // */
    public func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: BUNativeExpressAdView) {
        logPrint("===AdFeed===nativeExpressAdViewRenderSuccess\(nativeExpressAdView.frame)")
        //CCLogUtil.log("===AdFeed===RenderSuccess时候的高度: \(nativeExpressAdView.frame)")
        //nativeExpressAdViewRender(true, nativeExpressAdView.frame)


        CCLogUtil.log("ad0")
        var adModel = self.expressAdModels.first { $0.expressAdView == nil }
        //var adModelIndex = self.expressAdModels.firstIndex { $0.expressAdView == nil }
        for (index, model) in self.expressAdModels.enumerated() {
            if model.expressAdView == nil {
                CCLogUtil.log("ad填充前: 第一个即位置为\(model.index) \(index)的expressAdView\(adModel?.expressAdView == nil ? "空" : "有值")")
                adModel = model
                break
            }
        }

        if let adModel = adModel {
            let adHeight = nativeExpressAdView.frame.size.height
            adModel.updateRenderSuccess(expressAdView: nativeExpressAdView, adViewHeight: adHeight)
            CCLogUtil.log("ad填充后: 第一个即位置为\(adModel.index)的expressAdView为空的，现在：\(adModel.expressAdView == nil ? "空" : "有值")")

            for (index, model) in self.expressAdModels.enumerated() {
                if model.expressAdView == nil {
                    CCLogUtil.log("ad填充后验证: 下一个expressAdView\(model.expressAdView == nil ? "空" : "有值") 的位置为 \(model.index) \(index)")
                    break
                }
            }

            self.adViewRenderSuccessBlock(adModel)
//            var reloadItems: [IndexPath] = []
//            reloadItems.append(adModel.indexPath)
//            self.collection.reloadItems(at: reloadItems)
        }

//        let adHeight = nativeExpressAdView.frame.size.height
//        let expressAdModel = CCExpressAdModel(expressAdView: nativeExpressAdView, adViewHeight: adHeight)
//        self.expressAdModels.append(expressAdModel)
        /*
        var reloadItems: [IndexPath] = []
        for (index, model) in self.adForModels.enumerated() {
            model.adViewHeight = nativeExpressAdView.frame.height
            model.expressAdView = nativeExpressAdView

            if model.indexPath != nil {
                reloadItems.append(model.indexPath!)
            }
        }
        if reloadItems.count > 0 {
            self.collectionView.reloadItems(at: reloadItems)
        } else {
            self.collectionView.reloadData()
        }
        */
    }

    ///**
    // * This method is called when a nativeExpressAdView failed to render
    // */
    public func nativeExpressAdViewRenderFail(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        logPrint("===AdFeed===nativeExpressAdViewRenderFail:\(error.debugDescription)")
        CCLogUtil.log("ad render失败")
        //nativeExpressAdViewRender(false, nativeExpressAdView.frame)
        let adModel = self.expressAdModels.first { $0.expressAdView == nil }
        if let adModel = adModel {
            adModel.loadState = .renderFailure
        }
        self.adViewRenderFailureBlock()
    }

    ///**
    // * Sent when an ad view is about to present modal content
    // */
    public func nativeExpressAdViewWillShow(_ nativeExpressAdView: BUNativeExpressAdView) {
        logPrint("===AdFeed===nativeExpressAdViewWillShow")
    }


    ///**
    // * Sent when an ad view is clicked
    // */
    public func nativeExpressAdViewDidClick(_ nativeExpressAdView: BUNativeExpressAdView) {
        logPrint("===AdFeed===nativeExpressAdViewDidClick:")
    }


    ///**
    //Sent when a playerw playback status changed.
    //@param playerState : player state after changed
    //*/
    public func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, stateDidChanged playerState: BUPlayerPlayState) {
        logPrint("===AdFeed===nativeExpressAdView:\(playerState)")
    }

    ///**
    // * Sent when a player finished
    // * @param error : error of player
    // */
    public func nativeExpressAdViewPlayerDidPlayFinish(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        logPrint("===AdFeed===nativeExpressAdViewPlayerDidPlayFinish:\(error.debugDescription)")
    }


    ///**
    // * Sent when a user clicked dislike reasons.
    // * @param filterWords : the array of reasons why the user dislikes the ad
    // */
    public func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, dislikeWithReason filterWords: [BUDislikeWords]) {
        logPrint("===AdFeed===nativeExpressAdViewDislikeWithReason:\(filterWords)")
    }


    ///**
    // * Sent after an ad view is clicked, a ad landscape view will present modal content
    // */
    public func nativeExpressAdViewWillPresentScreen(_ nativeExpressAdView: BUNativeExpressAdView) {
        logPrint("===AdFeed===nativeExpressAdViewWillPresentScreen")
    }


    ///**
    // This method is called when another controller has been closed.
    // @param interactionType : open appstore in app or open the webpage or view video ad details page.
    // */
    public func nativeExpressAdViewDidCloseOtherController(_ nativeExpressAdView: BUNativeExpressAdView, interactionType: BUInteractionType) {
        logPrint("===AdFeed===nativeExpressAdViewDidCloseOtherController:interactionType:\(interactionType)")
    }


    //
    ///**
    // This method is called when the Ad view container is forced to be removed.
    // @param nativeExpressAdView : Ad view container
    // */
    public func nativeExpressAdViewDidRemoved(_ nativeExpressAdView: BUNativeExpressAdView) {
        logPrint("===AdFeed===nativeExpressAdViewDidRemoved")
    }
    
    
    //MARK: Private
    private func logPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        debugPrint(items, separator: separator, terminator: terminator)
    }
}
