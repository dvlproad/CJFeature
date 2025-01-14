//
//  ControlWidgetCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit

class CQControlWidgetCollectionView: UICollectionView {
    var dataModels: [BaseControlWidgetEntity] = []
//    var onTapIndexPath: ((IndexPath) -> Void)
    var onTapEntity: ((BaseControlWidgetEntity) -> Void)
    
    // 初始化方法
    init(frame: CGRect,
         onTapEntity: @escaping (BaseControlWidgetEntity) -> Void)
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        self.onTapEntity = onTapEntity
        super.init(frame: frame, collectionViewLayout: layout)
        
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // 注册 Cell 类型
        register(CQControlWidgetCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CQControlWidgetCollectionViewCell.self))
        
        // 设置数据源和代理
        dataSource = self
        delegate = self
    }
    
    public func setDataModels(_ dataModels: [BaseControlWidgetEntity]) {
        self.dataModels = dataModels
        reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension CQControlWidgetCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = dataModels[indexPath.row]
        onTapEntity(dataModel)
    }
}

// MARK: - UICollectionViewDataSource
extension CQControlWidgetCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count // 假设有 20 个数据项
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataModel = dataModels[indexPath.row]
        
        let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CQControlWidgetCollectionViewCell.self), for: indexPath) as! CQControlWidgetCollectionViewCell
        //cell.backgroundColor = .red
        cell.setEntity(dataModel)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CQControlWidgetCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataModel = dataModels[indexPath.row]
        
        let widgetStyle = dataModel.widgetStyle
        var columnCount: Int
        var widthHeightRatio: CGFloat
        let uiitemHeight = 95.0
        switch widgetStyle {
        case .circle:
            columnCount = 4
            widthHeightRatio = 73/uiitemHeight
        case .rectangle:
            columnCount = 2
            widthHeightRatio = 165/uiitemHeight
        case .square:
            columnCount = 1
            widthHeightRatio = 351/uiitemHeight
        }
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionWidth = collectionView.frame.size.width //UIScreen.main.bounds.width
        let itemsWithSpacingWidth = collectionWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let itemsWidth = itemsWithSpacingWidth - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = floor(itemsWidth / CGFloat(columnCount))
        let itemHeight = floor(itemWidth / widthHeightRatio)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
