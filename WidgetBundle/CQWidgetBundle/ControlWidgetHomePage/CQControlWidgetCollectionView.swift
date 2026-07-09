//
//  CQControlWidgetCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import CJCollectionViewLayout_Swift

import SwiftUI
struct CQControlWidgetCollectionViewRepresentable: UIViewRepresentable {
    let dataModels: [BaseControlWidgetSetModel]
    let onTapEntity: (BaseControlWidgetSetModel) -> Void
    
    func makeUIView(context: Context) -> CQControlWidgetCollectionView {
        CQControlWidgetCollectionView(frame: .zero, onTapEntity: onTapEntity)
    }
    
    func updateUIView(_ uiView: CQControlWidgetCollectionView, context: Context) {
        uiView.setDataModels(dataModels)
    }
}

public class CQControlWidgetCollectionView: UICollectionView {
    public var dataModels: [BaseControlWidgetSetModel] = []
//    var onTapIndexPath: ((IndexPath) -> Void)
    var onTapEntity: ((BaseControlWidgetSetModel) -> Void)
    
    // 初始化方法
    public init(
        frame: CGRect,
        onTapEntity: @escaping (BaseControlWidgetSetModel) -> Void
    ) {
        let layout = CJLeftAlignedFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 18, left: 15, bottom: 22, right: 15)
        layout.minimumInteritemSpacing = 22.0
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
        register(CQControlWidgetEntityCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CQControlWidgetEntityCollectionViewCell.self))
        register(CQControlWidgetGroupCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CQControlWidgetGroupCollectionViewCell.self))
        
        // 设置数据源和代理
        dataSource = self
        delegate = self
    }
    
    public func setDataModels(_ dataModels: [BaseControlWidgetSetModel]) {
        self.dataModels = dataModels
        reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension CQControlWidgetCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = dataModels[indexPath.row]
        onTapEntity(dataModel)
    }
}

// MARK: - UICollectionViewDataSource
extension CQControlWidgetCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count // 假设有 20 个数据项
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataModel = dataModels[indexPath.row]
        if dataModel.entitys.count == 1 {
            let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CQControlWidgetEntityCollectionViewCell.self), for: indexPath) as! CQControlWidgetEntityCollectionViewCell
//            cell.backgroundColor = .red
            cell.setEntity(dataModel.entitys[0])
            return cell
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CQControlWidgetGroupCollectionViewCell.self), for: indexPath) as! CQControlWidgetGroupCollectionViewCell
//        cell.backgroundColor = .red
        cell.configure(
            tapSelfHandler: { [weak self] in
                self?.onTapEntity(dataModel)
            }, tapGroupItemHandler: { [weak self] groupItemModel in
                self?.onTapEntity(dataModel)
            }
        )
        cell.setModel(dataModel)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CQControlWidgetCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let setModel = dataModels[indexPath.row]
        let setEntitys = setModel.entitys
        
        
        var columnCount: Int
        var topWidthHeightRatio: CGFloat // 除文字和间距外的顶部视图的宽高比
        var imageDistanceAndImageHeight: CGFloat
        if setEntitys.count > 1 {
            columnCount = 1
            topWidthHeightRatio = 351/95.0
            imageDistanceAndImageHeight = 7.5+12
        } else { //if setEntitys.count == 1
            let widgetStyle = setEntitys[0].widgetStyle
            switch widgetStyle {
            case .circle:
                columnCount = 4
                topWidthHeightRatio = 72.5/72.5
                imageDistanceAndImageHeight = 10+12
            case .rectangle:
                columnCount = 2
                topWidthHeightRatio = 165/75.0
                imageDistanceAndImageHeight = 8+12
            case .square:
                columnCount = 1
                topWidthHeightRatio = 351/95.0
                imageDistanceAndImageHeight = 7.5+12
            }
        }
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionWidth = collectionView.frame.size.width //UIScreen.main.bounds.width
        let itemsWithSpacingWidth = collectionWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let itemsWidth = itemsWithSpacingWidth - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = floor(itemsWidth / CGFloat(columnCount))
        let itemTopHeight = floor(itemWidth / topWidthHeightRatio)
        let itemHeight = itemTopHeight + imageDistanceAndImageHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
