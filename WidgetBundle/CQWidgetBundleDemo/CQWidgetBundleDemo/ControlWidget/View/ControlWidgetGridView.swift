//
//  ControlWidgetGridView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/20.
//
//  控制中心套图列表页

import SwiftUI
import CJListKit_Swift
import CQWidgetBundleCommon

//  控制中心套图列表页：顶部的集合视图
struct ControlWidgetGridView: View {
    var maxCount: Int?
    var dataModels: [BaseControlWidgetEntity]
    @Binding var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    
    var body: some View {
        CJEdgeInsetGridView(
            backgroundView: {
                Color(hex: "#F5F5F5")
            },
            contentEdgeInset: UIEdgeInsets(top: 39.0, left: 12.0, bottom: 39.0, right: 12.0),
            contentBackgroundColor: Color(hex: "#EBEBEB"),
            contentCornerRadius: 22.5,
            disabledScroll: true,
            cellEdgeInset: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0),
            itemsPerRow: 4,
            cellItemSpacing: 16.0,
            rowHeight: 70,
            cellSizeForIndex: { index in
                return 70
            },
            cellViewGetter: { dataModel, isSelected in
                ControlWidgetView(
                    subScale: 1.0,
                    cornerRadius: nil,
                    borderColor: Color(hex: "#F5F5F5"),
                    borderWidth: isSelected ? 1 : 0,
                    dataModel: dataModel,
                    pageInfo: CCPageInfo(pageType: .controlWidgetDetailPage),
                    enableTintColorIfExsit: $enableTintColor
                )
                
            },
            maxRowCount: 2,
            dataModels: self.dataModels
        )
    }
}
