//
//  TypeOneCell.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/5.
//

import UIKit
import SwiftUI

class TypeOneCell: UICollectionViewCell {
    // 定义 TypeOneCell 的 UI 组件和布局
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 添加和配置 UI 组件
        backgroundColor = .blue
    }
}

class TypeTwoCell2: UICollectionViewCell {
    // 定义 TypeTwoCell 的 UI 组件和布局
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 添加和配置 UI 组件
        backgroundColor = .green
    }
}

class TypeTwoCell: UICollectionViewCell {
    
    static let kReuseIdentifier = "PagingListBaseCell"
    var hostingController: UIHostingController<AnyView>?

    // 移除了内部模型定义，将它们作为外部配置的一部
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        let bannerAdModel = AdConfigModel(type: "4", adId: "103320730", adArgument: "SearchResultsBanner")
//        
//        let adView = CCAdView(
//            adConfigModel: bannerAdModel,
//            adWidth: screenWidth-2*12,
//            currentAdViewHeight: 84,
//            adViewHeightChangeBlock: { newAdViewHeight in
////                    model.adViewHeight = newAdViewHeight
////                adViewHeightChangeBlock(newAdViewHeight)
//            },
//            isReloadToUpdateAdViewHeight: false
//        )
//        self.adView = adView
        
//        self.configureAd(with: TSDataModel()) { newAdViewHeight in
//            
//        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // commonInit 移到配置方法中
    }
    
    var adView: CCAdView?
    func configureAd(with model: TSDataModel,
                     adViewHeightChangeBlock: @escaping ((_ newAdViewHeight: CGFloat) -> Void) // 新的高度，广告展示出来时候高度要自动变化
    ) {
        if self.adView == nil {
            let bannerAdModel = AdConfigModel(type: "4", adId: "103320730", adArgument: "SearchResultsBanner")
            
            let adView = CCAdView(
                adConfigModel: bannerAdModel,
                adWidth: screenWidth-2*12,
                currentAdViewHeight: model.adViewHeight,
                adViewHeightChangeBlock: { newAdViewHeight in
//                    model.adViewHeight = newAdViewHeight
                    adViewHeightChangeBlock(newAdViewHeight)
                },
                isReloadToUpdateAdViewHeight: model.isReloadToUpdateAdViewHeight
            )
            self.adView = adView
        } else {
//            self.adView?.setupAdViewHeightChangeBlock(adViewHeightChangeBlock: { newAdViewHeight in
//                //                    model.adViewHeight = newAdViewHeight
//                                    adViewHeightChangeBlock(newAdViewHeight)
//            })
            self.adView?.updateSuccess(adViewHeight: model.adViewHeight)
        }
        
        if self.hostingController != nil {
//            return
        }
        
        let rootView = AnyView(self.adView)
        self.hostingController = UIHostingController(rootView: rootView)
        
        
        
        guard let hostingView = hostingController?.view else { return }
        contentView.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        hostingView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 重置 hostingController 或其视图状态
        hostingController?.rootView = AnyView(EmptyView())
    }

}
