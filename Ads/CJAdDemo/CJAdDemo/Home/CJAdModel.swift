//
//  CJAdModel.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/7.
//

import Foundation

//enum CCAdLoadState: String {
//    case loading
//    case renderSuccess
//    case loadOrRenderFailure
//}
enum CCAdState {
    case unknown
    case loading
    case loadedSuccess
    case loadedFailure
    case renderSuccess
    case renderFailure
}

class CCAdModel {
    var index: Int = -1
    var insertIndex: Int = -1
}

import BUAdSDK
class CCLoadAdModel {
    var indexPath: IndexPath    // 广告位于列表哪个位置
    var index: Int              // 在整个列表中是第几个广告
    var loadState: CCAdState = .loading
    var loadStartDate: Date?
    var nativeExpressAdManager: BUNativeExpressAdManager?
    
    var expressAdView: UIView?
    var adViewHeight: CGFloat?
    
    init(indexPath: IndexPath, index: Int) {
        self.indexPath = indexPath
        self.index = index
    }
    
    func changeToLoadingState() {
        self.loadState = .loading
        self.loadStartDate = Date()
    }

    func updateRenderSuccess(expressAdView: UIView, adViewHeight: CGFloat) {
        self.loadState = .renderSuccess
        self.expressAdView = expressAdView
        self.adViewHeight = adViewHeight
    }
    
    func shouldReload() -> Bool {
        if loadState == .loadedFailure || loadState == .renderFailure {
            return true
        } 
//        else if loadState == .loading {
//            let timeInterval: TimeInterval = Date().timeIntervalSince(loadStartDate ?? Date())
//            return timeInterval > 5
//        }
        
        return false
    }
}


class CCExpressAdModel {
//    var positionModel: CCAdModel = CCAdModel()
    
    var expressAdView: UIView
    var adViewHeight: CGFloat
    
//    init(positionModel: CCAdModel) {
//        self.positionModel = positionModel
//    }
    
    init(expressAdView: UIView, adViewHeight: CGFloat) {
        self.expressAdView = expressAdView
        self.adViewHeight = adViewHeight
    }
}


