//
//  IconScrollView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import SwiftUI

struct IconScrollView: View {
    var maxCount: Int?
    @State var dataModels: [CJBaseImageModel] = []
    @Binding var currentDataModel: CJBaseImageModel?
    @Binding var enableTintColor: Bool // 是否显示tintColor，控制中心图标关闭状态时候不显示
    var onChangeOfDataModel: ((_ newDataModel: CJBaseImageModel) -> Void)
    var onTapMore: (() -> Void)
    
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
    
//    @State private var egIconModels: [CJBaseImageModel] = []    // 开启和关闭使用同一份图标库（区别是关闭时候，从图标库中选择图标要去掉颜色）
//    egIconModels = CQControlWidgetExample.iconExamples()
    private func requestData() {
        // 1秒后执行 //TODO: qian
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            let recommendIconModels: [CJBaseImageModel] = CQControlWidgetExample.iconExamples()
            dataModels = recommendIconModels
        }
        
//        CCRequestUtil.requestControlWidgetDatas(
//            API.ctrIconAll,
//            successCallback: { (recommendIconModels: [CJBaseImageModel], responseModel) in
//                dataModels = recommendIconModels
//            }, failureCallback: { (responseModel) in
//                print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
//            }
//        )
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
