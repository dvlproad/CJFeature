//
//  CQControlWidgetMyCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SwiftUI

class CQControlWidgetMyCollectionView: UICollectionView {
    private var dataModels: [BaseControlWidgetEntity] = []
//    var onTapIndexPath: ((IndexPath) -> Void)
    var onTapEntity: ((BaseControlWidgetEntity) -> Void)
    var deleteCompleteBlock: (()->Void)?
    
    var emptyView: UIView
    
    // 初始化方法
    init(frame: CGRect,
         onTapEntity: @escaping (BaseControlWidgetEntity) -> Void,
         deleteCompleteBlock: @escaping (()->Void)
    )
    {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 14)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        self.onTapEntity = onTapEntity
        self.deleteCompleteBlock = deleteCompleteBlock
        self.emptyView = CQControlWidgetMyEmptyView()
        super.init(frame: frame, collectionViewLayout: layout)
        
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // 注册 Cell 类型
        register(CQControlWidgetMyCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CQControlWidgetMyCollectionViewCell.self))
        
        // 设置数据源和代理
        dataSource = self
        delegate = self
        
        addUIView(emptyView)
    }
    
    public func updateDataModels(_ dataModels: [BaseControlWidgetEntity]) {
        self.emptyView.isHidden = dataModels.count != 0
        self.dataModels = dataModels
        reloadData()
    }
    
    var isDeleteState: Bool = false
    public func setIsDeleteState(_ isDeleteState: Bool) {
        self.isDeleteState = isDeleteState
        self.reloadData()
    }
    
    // 添加到 uiView ,并设置约束
    private func addUIView(_ uiView: UIView) {
        self.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: self.topAnchor),
            uiView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension CQControlWidgetMyCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = dataModels[indexPath.row]
        onTapEntity(dataModel)
    }
}

// MARK: - UICollectionViewDataSource
extension CQControlWidgetMyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count // 假设有 20 个数据项
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataModel = dataModels[indexPath.row]
        
        let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CQControlWidgetMyCollectionViewCell.self), for: indexPath) as! CQControlWidgetMyCollectionViewCell
        //cell.backgroundColor = .red
        cell.configureDeleteCompleteBlock { [weak self] in
            self?.deleteCompleteBlock?()
        }
        cell.setEntity(dataModel)
        cell.updateButtonState(isDeleteButton: self.isDeleteState)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CQControlWidgetMyCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataModel = dataModels[indexPath.row]
        
        let columnCount = 1
        var itemHeight: CGFloat
        let widgetStyle = dataModel.widgetStyle
        switch widgetStyle {
        case .circle:
            itemHeight = 59.0
        case .rectangle:
            itemHeight = 57.0
        case .square:
            itemHeight = 95.0
        }
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionWidth = collectionView.frame.size.width //UIScreen.main.bounds.width
        let itemsWithSpacingWidth = collectionWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let itemsWidth = itemsWithSpacingWidth - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = itemsWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
}




@objc public class CQControlWidgetMyEmptyView: UIView {
    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 从 swiftuiView 生成 uiView ，并显示到视图中
    private var hostingController: UIViewController?
    private func setupViews() {
        let swiftuiView = MyWidgetCellNoDataView(
            dismiss:{
                NotificationCenter.default.post(name: Notification.Name("kDefaultKey_pop_myWidget"), object: nil)
            }
        )
        let hostingController = UIHostingController(rootView: swiftuiView)
        self.hostingController = hostingController
        
        let uiView: UIView = hostingController.view ?? UIView()
        self.showUIView(uiView)
    }
    
    // 添加到 uiView ,并设置约束
    private func showUIView(_ uiView: UIView) {
        self.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: self.topAnchor),
            uiView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


struct MyWidgetCellNoDataView:View {
    var dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0){
            Image("myWidget_noData")
                .resizable()
                .frame(width: 209,height: 157)
            Spacer()
                .frame(height: 27)
            Text("还没有添加组件，赶紧去添加吧~")
                .font(.system(size: 12))
                .foregroundColor(title3Color)
            Spacer()
                .frame(height: 41)
            CustomButton(tapComplete: {
//                UMAnalyticsSwift.event(eventId: "My_Widget", attributes: ["MyWidget":"添加小组件"])
                dismiss()
            }, labelView: {
                Text("添加小组件")
                    .foregroundColor(title3Color)
                    .font(.system(size: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 19, style: .continuous)
                            .stroke(Color(hex: "#DEDEDE"), lineWidth: 1)
                            .frame(width: 157,height: 38)
                    )
            }, bgColor: .clear, radius: 19)
            .frame(width: 157,height: 38)
            
        }.frame(width: screenWidth - 30,height: screenHeight - UIDevice.xp_navigationFullHeight() - UIDevice.xp_tabBarFullHeight() - 60)
        
    }
}
