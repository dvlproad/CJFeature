//
//  ControlWidgetCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit

@objc public class ControlWidgetHomePreviewCollectionView: UICollectionView {
    var dataModels: [ControlWidgetPreviewModel] = []
//    var onTapIndexPath: ((IndexPath) -> Void)
    var onTapEntity: ((ControlWidgetPreviewModel) -> Void)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 初始化方法
    @objc public init(frame: CGRect,
         onTapEntity: @escaping (ControlWidgetPreviewModel) -> Void)
    {
        let layout = CJLeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        
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
        register(ControlWidgetEntityPreviewCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ControlWidgetEntityPreviewCollectionViewCell.self))
        register(ControlWidgetPreviewGroupCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ControlWidgetPreviewGroupCollectionViewCell.self))
        
        backgroundColor = .clear
        // 设置数据源和代理
        dataSource = self
        delegate = self
        
        NotificationCenter.default.addObserver(forName: Notification.Name("kNoti_Get_NewSymbols"), object: nil, queue: .main) { _ in
            self.reloadData()
        }
    }
    
    public func setDataModels(_ dataModels: [ControlWidgetPreviewModel]) {
        self.dataModels = dataModels
        reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension ControlWidgetHomePreviewCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = dataModels[indexPath.row]
        onTapEntity(dataModel)
    }
}

// MARK: - UICollectionViewDataSource
extension ControlWidgetHomePreviewCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count // 假设有 20 个数据项
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataModel = dataModels[indexPath.row]
        if dataModel.type == .component {
            let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ControlWidgetEntityPreviewCollectionViewCell.self), for: indexPath) as! ControlWidgetEntityPreviewCollectionViewCell
            //cell.backgroundColor = .red
            cell.setEntity(dataModel)
            return cell
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ControlWidgetPreviewGroupCollectionViewCell.self), for: indexPath) as! ControlWidgetPreviewGroupCollectionViewCell
        //cell.backgroundColor = .red
        cell.configure(
            tapSelfHandler: { [weak self] in
                self?.onTapEntity(dataModel)
            }, tapGroupItemHandler: { [weak self] groupItemModel in
                self?.onTapEntity(dataModel)
            }
        )
        
        let groupName = dataModel.name
        //let groupItemModels = dataModel.entitys
        var groupItemModels: [ControlWidgetPreviewItemModel] = []
        for groupModel in dataModel.groupModels {
            for groupItemModel in groupModel.entitys {
                groupItemModels.append(groupItemModel)
            }
        }
        cell.setGroup(groupName, groupItemModels: groupItemModels)
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ControlWidgetHomePreviewCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 15, bottom: 22, right: 15)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22.0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let columnSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let collectionWidth = collectionView.frame.size.width //UIScreen.main.bounds.width
        let itemsWithSpacingWidth = collectionWidth - sectionInset.left - sectionInset.right
        
        let setModel = dataModels[indexPath.row]
        let setEntitys = setModel.entitys
        
        
        var columnCount: Int
        var topWidthHeightRatio: CGFloat // 除文字和间距外的顶部视图的宽高比
        var imageDistanceAndImageHeight: CGFloat
        if setModel.type == .set {
            columnCount = 1
            let groupcolumnCount = 4
            let groupRowCount = (setModel.groupModels.count-1) / 4 + 1
            let groupSectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            
            let groupcolumnSpacing = 16.0
            let groupCollectionWidth = itemsWithSpacingWidth
            let groupitemsWithSpacingWidth = groupCollectionWidth - groupSectionInset.left - groupSectionInset.right
            let groupitemsWidth = groupitemsWithSpacingWidth - groupcolumnSpacing * CGFloat(groupcolumnCount - 1)
            let groupitemWidth = floor(groupitemsWidth / CGFloat(groupcolumnCount))
            let groupitemHeight = groupitemWidth
            let groupCollectionHeight = groupSectionInset.top + groupSectionInset.bottom + CGFloat(groupRowCount) * groupitemHeight + CGFloat(groupRowCount-1) * groupcolumnSpacing
            topWidthHeightRatio = groupCollectionWidth/groupCollectionHeight
            
//            let groupItemWidth = 70.0
//            topWidthHeightRatio = 351/(2*12.5+CGFloat(groupRowCount) * 70.0 + CGFloat(groupRowCount-1) * 16)
            
            imageDistanceAndImageHeight = 7.5+12
            
        } else { //if setEntitys.count == 1
            let widgetStyle = setModel.style
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

        
        
        let itemsWidth = itemsWithSpacingWidth - columnSpacing * CGFloat(columnCount - 1)
        let itemWidth = floor(itemsWidth / CGFloat(columnCount))
        let itemTopHeight = floor(itemWidth / topWidthHeightRatio)
        let itemHeight = itemTopHeight + imageDistanceAndImageHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
