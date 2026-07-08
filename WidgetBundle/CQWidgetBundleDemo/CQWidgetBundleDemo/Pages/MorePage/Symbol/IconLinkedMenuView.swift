//
//  TSLinkedCollectionMenuViewController.swift
//  CJListDemo-Swift
//
//  Created by qian on 2025/1/17.
//

import UIKit
import SnapKit
import CJListKit_Swift
import CQWidgetBundleCommon

public class IconLinkedMenuView: UIView {
    // cell 的高度
    private var rightColumnCount: Int
    private var layoutModel: CJLinkedMenuLayoutModel
    public var isForCloseState: Bool
    public var alwaysDisableTintColor: Bool // 有时候即使是开启状态的图标，如快捷启动应用的开启状态图标，也会有可能强制要求不显示tintColor
    private var selectedImageName: String
    private var onTapRightIndexPath: ((IndexPath, _ newImageModel: CJBaseImageModel) -> Void)
    private var requestDataHandler: ((@escaping ([IconLinkMenuSectionModel]) -> Void, @escaping (Error) -> Void) -> Void)?
    public init(
        rightColumnCount: Int,
        layoutModel: CJLinkedMenuLayoutModel,
        isForCloseState: Bool,
        alwaysDisableTintColor: Bool,
        selectedImageName: String,
        onTapRightIndexPath: @escaping (IndexPath, _ newImageModel: CJBaseImageModel) -> Void,
        requestDataHandler: ((@escaping ([IconLinkMenuSectionModel]) -> Void, @escaping (Error) -> Void) -> Void)? = nil
    ) {
        self.rightColumnCount = rightColumnCount
        self.layoutModel = layoutModel
        self.isForCloseState = isForCloseState
        self.alwaysDisableTintColor = alwaysDisableTintColor
        self.selectedImageName = selectedImageName
        self.onTapRightIndexPath = onTapRightIndexPath
        self.requestDataHandler = requestDataHandler
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private var leftDataSource: GuideMenuDataSource!
    private var rightDataSource: IconRightMenuDataSource!
    private var menuView: CJLinkedCollectionMenuView!
    private func setupViews() {
        self.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        
        let enableTintColor = alwaysDisableTintColor ? false : (isForCloseState ? false : true)
        self.rightDataSource = IconRightMenuDataSource(sectionDataModels: [], enableTintColor: enableTintColor)
        self.leftDataSource = GuideMenuDataSource()
        
        self.menuView = CJLinkedCollectionMenuView(leftWidth: 87, rightColumnCount: self.rightColumnCount, leftCellHeight: 45.0, layoutModel: self.layoutModel, leftSetupBlock: { leftTableView in
            self.leftDataSource.registerAllCells(for: leftTableView)
        }, leftDataSource: self.leftDataSource, rightSetupBlock: { rightCollectionView in
            self.rightDataSource.registerAllCells(for: rightCollectionView)
        }, rightDataSource: self.rightDataSource, onTapRightIndexPath: { indexPath in
            let dataModel = self.rightDataSource.dataModel(at: indexPath)
            self.onTapRightIndexPath(indexPath, dataModel)
        })
        self.addSubview(self.menuView)
        self.menuView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(0)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(-0)
        }
        
        // 请求数据
        self.requestData()
    }
    
    public func requestData() {
        requestDataHandler?({ [weak self] sectionDataModels in
            self?.setupDataSource(sectionDataModels: sectionDataModels)
        }, { error in
            print("图标菜单数据请求失败: \(error.localizedDescription)")
        })
    }
    
    private func setupDataSource(sectionDataModels: [IconLinkMenuSectionModel]) {
        var menuDataModels: [GuideMenuDataModel] = []
        var selectedIndexPaths: [IndexPath] = []
        
        let sectionCount = sectionDataModels.count
        for section in 0..<sectionCount {
            let sectionDataModel: IconLinkMenuSectionModel = sectionDataModels[section]
            let categoryModel: GuideMenuDataModel = sectionDataModel.categoryModel
            let menuDataModel: GuideMenuDataModel = categoryModel
            menuDataModels.append(menuDataModel)
            
            let valueCount = sectionDataModel.values.count
            for item in 0..<valueCount {
                let module: CJBaseImageModel = sectionDataModel.values[item] 
                if module.imageName == self.selectedImageName {
                    selectedIndexPaths.append(IndexPath(item: item, section: section))
                }
            }
        }
        self.rightDataSource.sectionDataModels = sectionDataModels
        self.leftDataSource.dataModels = menuDataModels
        self.menuView.reloadData()
        if sectionDataModels.count > 0, selectedIndexPaths.count == 0 {
            self.menuView.leftSelectedRowIndex(row: 0, animated: true, scrollPosition: .none)
        }
        self.menuView.updateSelectedIndexPaths(selectedIndexPaths, animated: true, scrollPosition: .centeredVertically)
    }
}
