//
//  CJFeedAdManager.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/2.
//

import BUAdSDK

class YourViewModel {
    var slotID: String = "your_slot_id" // 替换为实际的广告位 ID
    init(slotID: String) {
        self.slotID = slotID
    }
}

class YourAdManager: NSObject, BUNativeAdsManagerDelegate {
    private var nad: BUNativeAdsManager?
    private var viewModel: YourViewModel

    init(viewModel: YourViewModel) {
        self.viewModel = viewModel
        super.init()
        setupNativeAdsManager()
    }

    private func setupNativeAdsManager() {
        let slot = BUAdSlot()
        slot.id = viewModel.slotID
        slot.adType = .feed
        slot.position = .top
        slot.imgSize = BUSize(by: .feed690_388) // 690x388
        
        
        let nad = BUNativeAdsManager(slot: slot)
        nad.delegate = self
        nad.loadAdData(withCount: 1)

        self.nad = nad
    }

    // MARK: - BUNativeAdsManagerDelegate

    func nativeAdsManagerSuccess(toLoad ads: [BUNativeAd]?) {
        print("广告加载成功: \(String(describing: ads))")
    }

    func nativeAdsManager(_ adsManager: BUNativeAdsManager, didFailWithError error: Error?) {
        print("广告加载失败: \(error == nil ? "未知错误" : error!.cjErrorString)")
    }
}
