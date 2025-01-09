//
//  WidthAdCollectionView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/5.
//

import UIKit

class WidthAdCollectionView: UICollectionView {
    var dataModels: [TSDataModel] = []
    var adInstance: CJAdInstance!
    var adviewTopMargin: CGFloat = 0     // 广告视图顶部多占据的大小（用于历史其他cell高度设计不规范，导致在此cell内自动微调适配它）
    var adviewBottomMargin: CGFloat = 20 // 目前存在历史cell会超出它自身区域盖住了此cell底     // 广告视图底部多占据的大小（用于历史其他cell高度设计不规范，导致在此cell内自动微调适配它）
    
    // 初始化方法
    init(frame: CGRect,
         collectionViewLayout layout: UICollectionViewLayout,
         adRootViewController: UIViewController
    ) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
        
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 插入广告（
    func insertAd(adId: String, adRootViewController: UIViewController) {
        self.adInstance = CJAdInstance(adId: adId, adRootViewController: adRootViewController, adMaxCacheCount: 10, adviewRenderSuccessBlock: { loadAdModel in
            var reloadItems: [IndexPath] = []
            reloadItems.append(loadAdModel.indexPath)
            debugPrint("========cellForItemAt:计划处理广告\(loadAdModel.indexPath)")
            self.reloadItemsSafely(at: reloadItems)
        }, adviewRenderFailureBlock: {
            
        })
    }
    
    private func commonInit() {
        // 注册 Cell 类型
        register(TypeOneCell.self, forCellWithReuseIdentifier: "TypeOneCell")
        register(TypeTwoCell.self, forCellWithReuseIdentifier: "TypeTwoCell")
        register(CCAdCollectionCell.self, forCellWithReuseIdentifier: "CCAdCollectionCell")
        
        // 设置数据源和代理
        dataSource = self
        delegate = self
    }
    
    public func setDataModels(_ dataModels: [TSDataModel]) {
        self.dataModels = dataModels
        reloadData()
    }
    
    /// 从后台获取到广告位后，更新广告位
    public func updateAdId(_ adId: String) {
        self.adInstance.updateAdId(adId)
    }
}

// MARK: - UICollectionViewDataSource
extension WidthAdCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count // 假设有 20 个数据项
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("========cellForItemAt:正在处理\(indexPath)")
        let dataModel = dataModels[indexPath.row]
        
        if dataModel.isAdBannerModel {
            let cell = dequeueReusableCell(withReuseIdentifier: "CCAdCollectionCell", for: indexPath) as! CCAdCollectionCell
            // 配置 CCAdCollectionCell
            let adIndex = dataModel.adIndex
            let adView = self.adInstance.getAdviewAtAdIndex(adIndex)
            cell.showExpressView(adView, adviewTopMargin: adviewTopMargin, adviewBottomMargin: adviewBottomMargin)
            cell.updateTagLabel("\(indexPath.section)-\(indexPath.item):这是第\(adIndex)个广告")
            // 该广告还未加载出来则尝试加载(内部会判断如果正加载中则不用重发加载请求)
            if adView == nil {
                var itemWidth = UIScreen.main.bounds.width
                if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    itemWidth = UIScreen.main.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
                }
                self.adInstance.loadAdIndex(adIndex, adWidth: itemWidth, indexPath: indexPath)
            }
            
            return cell
        } else {
            let cell = dequeueReusableCell(withReuseIdentifier: "TypeOneCell", for: indexPath) as! TypeOneCell
            // 配置 TypeOneCell
            cell.titleLabel.text = "\(indexPath.section)-\(indexPath.item):\(dataModel.title)"
            return cell
        }
        
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WidthAdCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataModel = dataModels[indexPath.row]
        
        if dataModel.isAdBannerModel {
            var itemWidth = UIScreen.main.bounds.width
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                itemWidth = UIScreen.main.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            }
            
            let adIndex = dataModel.adIndex
            let adView = self.adInstance.getAdviewAtAdIndex(adIndex)
            let adviewHeight = adView?.frame.size.height ?? feedAdPlaceholderHeight
            let itemHeight = adviewHeight + adviewTopMargin + adviewBottomMargin

            return CGSize(width: floor(itemWidth), height: floor(itemHeight))
        } else {
            return CGSize(width: 150, height: 100) // TypeOneCell 的尺寸
        }
    }
}
