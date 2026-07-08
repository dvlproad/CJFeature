//
//  TSLinkedCollectionMenuViewController.swift
//  CJListDemo-Swift
//
//  Created by qian on 2025/1/17.
//

import UIKit
import SnapKit
import CJListKit_Swift

@objc public class TextLinkedMenuView: UIView {
    // cell 的高度
    private var rightColumnCount: Int
    private var layoutModel: CJLinkedMenuLayoutModel
    public var isForCloseState: Bool
    public var selectedText: String
    private var onTapRightIndexPath: ((IndexPath, _ newImageModel: TextLinkMenuDataModel) -> Void)
    private var requestDataHandler: ((@escaping ([TextLinkMenuSectionModel]) -> Void, @escaping (Error) -> Void) -> Void)?
    @objc public init(
        rightColumnCount: Int,
        layoutModel: CJLinkedMenuLayoutModel,
        isForCloseState: Bool,
        selectedText: String,
        onTapRightIndexPath: @escaping (IndexPath, _ newImageModel: TextLinkMenuDataModel) -> Void,
        requestDataHandler: ((@escaping ([TextLinkMenuSectionModel]) -> Void, @escaping (Error) -> Void) -> Void)? = nil
    ) {
        self.rightColumnCount = rightColumnCount
        self.layoutModel = layoutModel
        self.isForCloseState = isForCloseState
        self.selectedText = selectedText
        self.onTapRightIndexPath = onTapRightIndexPath
        self.requestDataHandler = requestDataHandler
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private var leftDataSource: GuideMenuDataSource!
    private var rightDataSource: TextRightMenuDataSource!
    private var menuView: CJLinkedCollectionMenuView!
    private func setupViews() {
        self.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        
        
        self.rightDataSource = TextRightMenuDataSource(sectionDataModels: [], enableTintColor: !isForCloseState)
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
            print("文本菜单数据请求失败: \(error.localizedDescription)")
        })
    }
    
    private func setupDataSource(sectionDataModels: [TextLinkMenuSectionModel]) {
        var menuDataModels: [GuideMenuDataModel] = []
        var selectedIndexPaths: [IndexPath] = []
        
        let sectionCount = sectionDataModels.count
        for section in 0..<sectionCount {
            let sectionDataModel: TextLinkMenuSectionModel = sectionDataModels[section]
            let categoryModel: GuideMenuDataModel = sectionDataModel.categoryModel
            let menuDataModel: GuideMenuDataModel = categoryModel
            menuDataModels.append(menuDataModel)
            
            let valueCount = sectionDataModel.values.count
            for item in 0..<valueCount {
                let module: TextLinkMenuDataModel = sectionDataModel.values[item] 
                if module.text == self.selectedText {
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
