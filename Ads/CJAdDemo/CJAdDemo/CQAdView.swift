//
//  CQAdView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/1.
//

import Foundation
import SwiftUI

struct CCAdView: View {
    var adConfigModel: AdConfigModel
    var adSize: CGSize
    @State var loadAdSuccess: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack(alignment: .center) {
                if !loadAdSuccess {
                    Image("placeholder_ad")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 42, height: 42)
                }
                CCAdvertiseViewRepresentable(
                    adConfigModel: adConfigModel,
                    adSize: CGSize(width: 338, height: 84),
                    placeholder: true,
                    nativeExpressAdSuccess: {
                        loadAdSuccess = true
                    }
                )
                Text(loadAdSuccess ? "加载成功" : "加载中...")
                    .background(Color.red)
                    .frame(width: 100, height: 40)
            }
            .frame(width: 338, height: 84)
            .background(Color.gray)
            .cornerRadius(13)
        }
        .frame(width: adSize.width, height: adSize.height)
        //.background(Color.blue)
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
