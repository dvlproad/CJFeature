//
//  ControlWidgetVerticalScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//
//  控制中心套图列表页

import SwiftUI
import CQWidgetBundleCommon

//  控制中心套图列表页：下部分竖直滚动的视图
public struct ControlWidgetVerticalScrollView: View {
    var maxCount: Int?
    var dataModels: [BaseControlWidgetEntity]
    @Binding var selectedIds: [String]
    @Binding var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    var onChangeOfSelectedIds: ((_ newSelectedIds: [String]) -> Void)
    
    public init(
        maxCount: Int? = nil,
        dataModels: [BaseControlWidgetEntity],
        selectedIds: Binding<[String]>,
        enableTintColor: Binding<Bool>,
        onChangeOfSelectedIds: @escaping (_ newSelectedIds: [String]) -> Void
    ) {
        self.maxCount = maxCount
        self.dataModels = dataModels
        self._selectedIds = selectedIds
        self._enableTintColor = enableTintColor
        self.onChangeOfSelectedIds = onChangeOfSelectedIds
    }
    
    public var body: some View {
        BaseIconsScrollView(
            direction: .vertical,
            cellItemSpacing: 0,
            cellSizeForIndex: { index in
                return (width: nil, height: 80)
            },
            cellViewGetter: { dataModel, isSelected, tapModelHandler in
                ControlWidgetVerticalCell(
                    dataModel: dataModel,
                    pageInfo: CCPageInfo(pageType: .controlWidgetDetailPage),
                    isSelected: isSelected,
                    enableTintColorIfExsit: $enableTintColor,
                    onTapCheckBox: {
                        tapModelHandler()
                    }
                )
            },
            dataModels: dataModels,
            selectedIds: $selectedIds,
            tapCountSupportMultiple: true,
            tapAgainShouldCancle: true,
            allowTapSelf: false,
            onTapDataModelComplete: { lastTapDataModel, newSelectedIds in
                onChangeOfSelectedIds(newSelectedIds)
            }
        )
        //.background(Color.red)
    }
}

//  控制中心套图列表页：下部分竖直滚动的视图中的Cell
public struct ControlWidgetVerticalCell: View {
    var dataModel: BaseControlWidgetEntity
    var pageInfo: CCPageInfo
    var isSelected: Bool
    @Binding var enableTintColorIfExsit: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    var onTapCheckBox: (() -> Void)? = nil
    
    public var body: some View {
        let cornerRadius: CGFloat = 10.0
        ZStack {
//            Color.randomColor
            
            HStack(alignment: .center, spacing: 0) {
                ControlWidgetView(
                    subScale: 1.0,
                    cornerRadius: nil,
                    borderColor: Color(hex: "#F5F5F5"),
                    borderWidth: isSelected ? 1 : 0,
                    dataModel: dataModel,
                    pageInfo: pageInfo,
                    enableTintColorIfExsit: $enableTintColorIfExsit
                )
                .frame(width: 55, height: 55)
                
                Text("\(dataModel.name)")
                    .font(.system(size: 13.5))
                    .foregroundColor(Color(hex: "#333333"))
                    .padding(.leading, 12.0)
                
                Spacer()
                Button(action: {
                    onTapCheckBox?()
                }) {
                    Image(isSelected ? "controlwidget_check_yes" : "controlwidget_check_no")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 确保label填充整个按钮区域，避免点击区域只有文字部分
                }
                //.background(Color.red)
                .frame(width: 55, height: 55)
                .contentShape(Rectangle())  // 确保整个区域都可以响应点击
            }
        }
    }
}

