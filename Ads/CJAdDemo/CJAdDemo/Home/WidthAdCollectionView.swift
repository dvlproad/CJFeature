//
//  WidthAdCollectionView.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/5.
//

import UIKit

class WidthAdCollectionView: UICollectionView {
    var dataModels: [TSDataModel] = []
    
    // 初始化方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // 注册 Cell 类型
        register(TypeOneCell.self, forCellWithReuseIdentifier: "TypeOneCell")
        register(TypeTwoCell.self, forCellWithReuseIdentifier: "TypeTwoCell")
        
        // 设置数据源和代理
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension WidthAdCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count // 假设有 20 个数据项
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
            let cell = dequeueReusableCell(withReuseIdentifier: "TypeOneCell", for: indexPath) as! TypeOneCell
            // 配置 TypeOneCell
            return cell
        } else {
            let cell = dequeueReusableCell(withReuseIdentifier: "TypeTwoCell", for: indexPath) as! TypeTwoCell
            // 配置 TypeTwoCell
            let dataModel = dataModels[indexPath.row]
            cell.configureAd(with: dataModel, adViewHeightChangeBlock: { newAdViewHeight in
//                var dataModel2 = self.dataModels[indexPath.row]
                dataModel.adViewHeight = newAdViewHeight
                dataModel.isReloadToUpdateAdViewHeight = true
//                collectionView.reloadData()
                collectionView.performBatchUpdates({
                    collectionView.reloadData()
//                    collectionView.reloadItems(at: [indexPath])   // 可能会导致单元格的 init 方法被调用，特别是在重用队列中没有可用单元格的情况下.
                }, completion: { finished in
                    dataModel.isReloadToUpdateAdViewHeight = false
                })
            })
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WidthAdCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataModel = dataModels[indexPath.row]
        if indexPath.row % 2 == 0 {
            return CGSize(width: 150, height: 100) // TypeOneCell 的尺寸
        } else {
            return CGSize(width: 200, height: dataModel.adViewHeight) // TypeTwoCell 的尺寸
        }
    }
}
