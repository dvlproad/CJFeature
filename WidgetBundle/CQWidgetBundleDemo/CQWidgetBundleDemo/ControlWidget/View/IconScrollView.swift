//
//  IconScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import SwiftUI

struct IconScrollView: View {
    var maxCount: Int?
    var dataModels: [CJBaseDataModel]
    @State var currentDataModel: CJBaseDataModel?
    var onChangeOfDataModel: ((_ newDataModel: CJBaseDataModel) -> Void)
    
    var body: some View {
        
        BaseIconsScrollView<CJNormalIcon, EmptyView, Button>(
            cellItemSpacing: 12,
            cellSizeForIndex: { index in
                return CGSize(width: 44, height: 44)
            },
            cellViewGetter: { dataModel, isSelected in
                CJNormalIcon(fontModel: dataModel, isSelected: isSelected)
            },
            maxCount: 10,
            bottomView: {
                Button {
                    
                } label: {
                    Text("更多 >")
                }

            },
            dataModels: dataModels,
            currentDataModel: currentDataModel,
            onChangeOfDataModel: onChangeOfDataModel
        )
        //.background(Color.red)
    }
}
