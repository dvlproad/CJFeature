//
//  ControlWidgetScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//
//  详情页中的包含控制项

import SwiftUI
import CQWidgetBundleCommon

struct ControlWidgetScrollView: View {
    var maxCount: Int?
    var dataModels: [BaseControlWidgetEntity]
    @Binding var currentDataModel: BaseControlWidgetEntity?
    @Binding var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    var onChangeOfDataModel: ((_ newDataModel: BaseControlWidgetEntity) -> Void)
    
    var body: some View {
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

/// 含选中边框的 ControlWidget 的视图
/// 目前使用到的地方有：
/// 1、控制中心套图列表页：顶部的集合视图（父视图圆角:圆形 ; 组件占主体比例: 1.0; 选中的边框颜色:不会有选中状态）
/// 2、控制中心套图列表页：下部分竖直滚动的视图中的Cell（父视图圆角:圆形0 ; 组件占主体比例: 1.0; 选中的边框颜色:#F5F5F5）
/// 3、详情页中的包含控制项    （父视图圆角:9.0 ; 组件占主体比例: 0.9; 选中的边框颜色:#2E2E2E）
public struct ControlWidgetView: View {
    var subScale: CGFloat // 组件占据父视图的大小（为1.0时候，占据整体)
    var cornerRadius: CGFloat?  // 父视图的圆角大小(不提供默认值,且值为nil时候展示为圆角，请不要随意更改)
    var borderColor: Color      // 父视图选中的边框颜色
    var borderWidth: CGFloat    // 父视图选中的边框大小
    
    var dataModel: BaseControlWidgetEntity
    var pageInfo: CCPageInfo
    @Binding var enableTintColorIfExsit: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    
    public var body: some View {
        GeometryReader { geometry in
            let cornerRadius: CGFloat = cornerRadius ?? geometry.size.width/2.0
            ZStack(alignment: .center){
//               fontModel.createImageView()
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(10)
                let scale = subScale
                let widgetSize = CGSize(width: geometry.size.width * scale, height: geometry.size.height * scale)
                // 内部会根据 entity.isOffInDetailPage 来判断显示
                BaseControlWidgetViewInApp(entity: dataModel, pageInfo: pageInfo)
                    .frame(width: widgetSize.width, height: widgetSize.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(hex: "#F5F5F5"))
//            .border(Color.pink, width: borderWidth)
//            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            // ZStack 的 background 和 border 不会被自动裁剪。这可能导致背景颜色（background) 和边框（border) 显示在圆角之外。
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 裁剪整个区域
        }
//        .controlWidget_tintColor((enableTintColorIfExsit && fontModel.imageColorString != nil) ? Color(hex: fontModel.imageColorString!) : nil, isInWidget: false)
    }
}
