//
//  CQControlWidgetMyView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SwiftUI
import CQWidgetBundleCommon

struct MyWidgetVC: View {
    static var isDeleteState = false
    
    var body: some View {
        Text("MyWidgetVC")
    }
}


struct CQControlWidgetMyViewRepresentable: UIViewRepresentable {
    let onTapEntity: (BaseControlWidgetEntity) -> Void
    
    func makeUIView(context: Context) -> CQControlWidgetMyView {
        let view = CQControlWidgetMyView(onTapEntity: onTapEntity)
        return view
    }
    
    func updateUIView(_ uiView: CQControlWidgetMyView, context: Context) {
        
    }
}

class CQControlWidgetMyView: UIView {
    var collectionView: CQControlWidgetMyCollectionView!
    
    var dataModels: [BaseControlWidgetEntity] = []
    var onTapEntity: ((BaseControlWidgetEntity) -> Void)

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(onTapEntity: @escaping (BaseControlWidgetEntity) -> Void) {
        self.onTapEntity = onTapEntity
        super.init(frame: .zero)
        
        setupViews()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("kNoti_Update_myControlWidgets"), object: nil, queue: .main) { _ in
            self.dataModels = TSWidgetBundleCacheUtil.getControlWidgetsForMyWidgets()
            self.collectionView.updateDataModels(self.dataModels)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: Notification.Name("kNoti_Update_myWidgets_eidtState"),
            object: nil
        )
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let isDeleteState = userInfo["isDeleteState"] as? Bool {
            self.collectionView.setIsDeleteState(isDeleteState)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setupViews() {
        self.backgroundColor = UIColor(hex: "#F5F5F5")

        self.setupCollectionView()
        // updateUIView 会在视图创建后立即调用，自动设置 isDeleteState
        
        dataModels = TSWidgetBundleCacheUtil.getControlWidgetsForMyWidgets()
        self.collectionView.updateDataModels(self.dataModels)
    }
    
    func setupCollectionView() {
        collectionView = CQControlWidgetMyCollectionView(frame: .zero, onTapEntity: onTapEntity, deleteCompleteBlock: {
            self.dataModels = TSWidgetBundleCacheUtil.getControlWidgetsForMyWidgets()
            self.collectionView.updateDataModels(self.dataModels)
        })
        collectionView.backgroundColor = UIColor.white
        collectionView.layer.cornerRadius = 13.5
        collectionView.layer.masksToBounds = true
        self.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.5),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.5),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

