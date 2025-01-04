//
//  CQAdView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import SwiftUI

enum CCADCauseType: String {
    case enterForeground  // 从后台回来
}

enum CCAdState {
    case unknown
    case loading
    case loadedSuccess
    case loadedFailure
    case renderSuccess
    case renderFailure
}

struct CCAdView: View {
    var adConfigModel: AdConfigModel
    var adWidth: CGFloat                // 广告不管显示不显示固定的宽度
    @State var currentAdViewHeight: CGFloat    // 当前广告视图的高度，广告展示和未显示时候高度一般会不一样
    var viewVerticalMargin: CGFloat = 10     // 广告视图竖直多占据的大小
    @State var adState: CCAdState = .unknown
    var adViewHeightChangeBlock: ((_ newAdViewHeight: CGFloat) -> Void) // 新的高度，广告展示出来时候高度要自动变化
    var isReloadToUpdateAdViewHeight: Bool
    
    @State private var adView: CCAdvertiseViewRepresentable?
    
    var adResult: String {
        var adResult: String = "未知"
        switch adState {
        case .loading:
            adResult = "加载中..."
        case .loadedSuccess:
            adResult = "加载成功"
        case .loadedFailure:
            adResult = "加载失败"
        case .renderSuccess:
            adResult = "渲染成功"
        case .renderFailure:
            adResult = "渲染失败"
        case .unknown:
            adResult = "未知"
            break
        }
        
        return adResult
    }

    var body: some View {
//        var adViewHeight: CGFloat = 0
//        if adState != .renderSuccess {
//            adViewHeight = adPlaceholderHeight
//        }
        
        VStack(alignment: .center) {
            ZStack(alignment: .center) {
                if adState != .renderSuccess {
                    Image("placeholder_ad")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 42, height: 42)
                }
                
                if let adView = adView {
                    adView // 显示已创建的 adView
                }
                
                
                /*
                Text(adResult)
                    //.background(Color.red)
                    .frame(width: 100, height: 40)
                */
            }
            .frame(width: adWidth, height:  adState == .renderSuccess ? nil : currentAdViewHeight)
            .background(Color.red)
            .cornerRadius(13)
        }
        .frame(width: adWidth, height: adState == .renderSuccess ? nil : currentAdViewHeight + 2*viewVerticalMargin)
        //.background(Color.blue)
        .onAppear() {
            if self.adView == nil {
                self.adView = CCAdvertiseViewRepresentable(
                    adConfigModel: adConfigModel,
                    adWidth: adWidth, adPlaceholderHeight: currentAdViewHeight,
                    placeholder: true,
                    nativeExpressAdLoad: { isSuccess in
                        adState = isSuccess ? .loadedSuccess : .loadedFailure
                    },
                    nativeExpressAdViewRender: { isSuccess, adFrame in
                        adState = isSuccess ? .renderSuccess : .renderFailure
                        if isSuccess {
                            adViewHeightChangeBlock(adFrame.height)
                        }
                    },
                    isReloadToUpdateAdViewHeight: isReloadToUpdateAdViewHeight
                )
            }
        }
    }
    
    mutating func setupAdViewHeightChangeBlock(adViewHeightChangeBlock: @escaping ((_ newAdViewHeight: CGFloat) -> Void)) {
        self.adViewHeightChangeBlock = adViewHeightChangeBlock
    }
    
    func updateSuccess(adViewHeight: CGFloat) {
        currentAdViewHeight = adViewHeight
    }
}

//// 预览 CCAdView
//struct CCAdView_Previews: PreviewProvider {
//    static var previews: some View {
//        CCAdView(
//            adConfigModel: AdConfigModel(type: "4", adId: "103161544", adArgument: "SearchResultsBanner"),
//            adSize: feedAdSize()
//        )
//        .previewLayout(.sizeThatFits)
//        .padding() // 给预览添加一些边距
//        .background(Color.blue) // 给预览添加一个白色背景
//    }
//}
