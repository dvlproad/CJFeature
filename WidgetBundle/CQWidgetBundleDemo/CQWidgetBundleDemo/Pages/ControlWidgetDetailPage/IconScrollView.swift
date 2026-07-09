//
//  IconScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import SwiftUI
import CQWidgetBundleCommon
import CQWidgetBundle

struct IconScrollView: View {
    var maxCount: Int?
    @State var dataModels: [CJBaseImageModel] = []
    @Binding var currentDataModel: CJBaseImageModel?
    @Binding var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    var onChangeOfDataModel: ((_ newDataModel: CJBaseImageModel) -> Void)
    var onTapMore: (() -> Void)
    var requestDataHandler: ((@escaping ([CJBaseImageModel]) -> Void, @escaping (Error) -> Void) -> Void)?
    
    var body: some View {
        
        BaseIconsScrollView(
            direction: .horizontal,
            cellItemSpacing: 12,
            cellSizeForIndex: { index in
                return (width: 44, height: 44)
            },
            cellViewGetter: { dataModel, isSelected, _ in
                CJNormalIcon(fontModel: dataModel, isSelected: isSelected, showTintColor: $enableTintColor)
                    //.background(Color.red)
            },
            maxCount: 10,
            bottomView: {
                IconMoreButton(onTapMore: onTapMore)
            },
            dataModels: dataModels,
            selectedDataModel: $currentDataModel,
            tapAgainShouldCancle: false,
            onTapDataModelComplete: { newDataModel in
                var resultDataModel = newDataModel
                if enableTintColor != true {
                    resultDataModel.imageColorString = nil  // 不支持tintColor的情况下不要把图片库中的该值传回，避免后续会使用到
                }
                onChangeOfDataModel(resultDataModel)
            }
        )
        //.background(Color.red)
        .onFirstAppear() {
            self.requestData()
        }
    }
    
    private func requestData() {
        requestDataHandler?({ dataModels in
            self.dataModels = dataModels
        }, { error in
            print("图标滚动视图数据请求失败: \(error.localizedDescription)")
        })
    }
}


public struct CJNormalIcon: View {
    var fontModel: CJBaseImageModel
    var isSelected: Bool
    @Binding var showTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    
    public var body: some View {
        let cornerRadius: CGFloat = 10.0
        GeometryReader { geometry in
            ZStack(alignment: .center){
               fontModel.createImageView()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(geometry.size.width * 0.2) // 外部占据 0.1=(1-0.8)/2.0
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(hex: "#F8F8F8"))
//            .border(Color.pink, width: isSelected ? 1 : 0)
//            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color(hex: "#333333"), lineWidth: isSelected ? 1 : 0)
                )
            // ZStack 的 background 和 border 不会被自动裁剪。这可能导致背景颜色（background) 和边框（border) 显示在圆角之外。
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 裁剪整个区域
        }
        .controlWidget_tintColor((showTintColor && fontModel.imageColorString != nil) ? Color(hex: fontModel.imageColorString!) : nil, isInWidget: false)
    }
}


struct IconMoreButton: View {
    var onTapMore: (() -> Void)
    
    var body: some View {
        Button {
            onTapMore()
        } label: {
            Text("更多")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(hex: "#999999"))
        }
        .frame(width: 44, height: 44, alignment: .center)
        .background(Color(hex: "#F5F5F5"))
        .cornerRadius(10)
    }
}


//#Preview {
//    CJFontIcon(fontModel: CJBaseDataModel(name: "fontImage_6", egImage: "fontImage_6"), isSelected: false)
//}
