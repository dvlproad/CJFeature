//
//  ControlWidgetScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//
//  详情页中的包含控制项

import SwiftUI
import CQWidgetBundleCommon

public struct ControlWidgetScrollView: View {
    var maxCount: Int?
    var dataModels: [BaseControlWidgetEntity]
    @Binding var currentDataModel: BaseControlWidgetEntity?
    @Binding var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    var onChangeOfDataModel: ((_ newDataModel: BaseControlWidgetEntity) -> Void)
    
    public init(
        maxCount: Int? = nil,
        dataModels: [BaseControlWidgetEntity],
        currentDataModel: Binding<BaseControlWidgetEntity?>,
        enableTintColor: Binding<Bool>,
        onChangeOfDataModel: @escaping (_ newDataModel: BaseControlWidgetEntity) -> Void
    ) {
        self.maxCount = maxCount
        self.dataModels = dataModels
        self._currentDataModel = currentDataModel
        self._enableTintColor = enableTintColor
        self.onChangeOfDataModel = onChangeOfDataModel
    }
    
    public var body: some View {
        BaseIconsScrollView(
            direction: .horizontal,
            cellItemSpacing: 12,
            cellSizeForIndex: { index in
                return (width: 44, height: 44)
            },
            cellViewGetter: { dataModel, isSelected, _ in
                // 内部会根据 entity.isOffInDetailPage 来判断显示
                ControlWidgetView(
                    subScale: 0.9,
                    cornerRadius: 9.0,
                    borderColor: Color(hex: "#2E2E2E"),
                    borderWidth: isSelected ? 1 : 0,
                    dataModel: dataModel,
                    pageInfo: CCPageInfo(pageType: .controlWidgetDetailPage),
                    enableTintColorIfExsit: $enableTintColor
                )
                
            },
            maxCount: 10,
            dataModels: dataModels,
            selectedDataModel: $currentDataModel,
            tapAgainShouldCancle: false,
            onTapDataModelComplete: { newDataModel in
                onChangeOfDataModel(newDataModel)
            }
        )
        //.background(Color.red)
    }
}
