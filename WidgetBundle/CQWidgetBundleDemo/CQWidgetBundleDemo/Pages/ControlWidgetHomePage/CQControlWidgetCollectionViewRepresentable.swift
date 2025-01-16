//
//  CQControlWidgetCollectionViewRepresentable.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/16.
//

import SwiftUI

struct CQControlWidgetCollectionViewRepresentable: UIViewRepresentable {
    var dataModels: [BaseControlWidgetEntity]
//    var onTapIndexPath: ((IndexPath) -> Void)
    var onTapEntity: ((BaseControlWidgetEntity) -> Void)
    
    func makeUIView(context: Context) -> CQControlWidgetCollectionView {
        //dataModels = CQControlWidgetIds.examples()
        
        return CQControlWidgetCollectionView(
            frame: .zero,
            onTapEntity: onTapEntity
        )
    }
    
    func updateUIView(_ uiView: CQControlWidgetCollectionView, context: Context) {
        // 更新视图，如果有需要的话
        uiView.dataModels = dataModels
    }
}
