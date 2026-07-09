//
//  ControlWidgetVerticalScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//
//  控制中心套图列表页

import SwiftUI
import CQWidgetBundleCommon
import CQWidgetBundle

/// 含选中边框的 ControlWidget 的视图
public struct ControlWidgetVerticalView: View {
    var dataModel: BaseControlWidgetEntity
    var pageInfo: CCPageInfo
    var isSelected: Bool
    @Binding var enableTintColorIfExsit: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    
    public var body: some View {
        let cornerRadius: CGFloat = 10.0
        GeometryReader { geometry in
            ZStack(alignment: .center) {
//               fontModel.createImageView()
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(10)
                let scale = 0.8
                let widgetSize = CGSize(width: geometry.size.width * scale, height: geometry.size.height * scale)
                // 内部会根据 entity.isOffInDetailPage 来判断显示
                BaseControlWidgetViewInApp(entity: dataModel, pageInfo: pageInfo)
                    .frame(width: widgetSize.width, height: widgetSize.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(hex: "#F5F5F5"))
//            .border(Color.pink, width: isSelected ? 1 : 0)
//            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color(hex: "#333333"), lineWidth: isSelected ? 1 : 0)
                )
            // ZStack 的 background 和 border 不会被自动裁剪。这可能导致背景颜色（background) 和边框（border) 显示在圆角之外。
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 裁剪整个区域
        }
//        .controlWidget_tintColor((enableTintColorIfExsit && fontModel.imageColorString != nil) ? Color(hex: fontModel.imageColorString!) : nil, isInWidget: false)
    }
}
