//
//  IconCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//


import SwiftUI
import CQWidgetBundleCommon


// MARK: 组件Data数据类
public struct CJBaseDataModel {
    public var id: String = ""          // 图片id
    public var name: String = ""        // 图片名称
    public var egImage: String = ""     // 图片地址
    
    public init(id: String, name: String, egImage: String) {
        self.id = id
        self.name = name
        self.egImage = egImage
    }
}

public extension CJBaseImageModel {
    func copyWithColorString(_ colorString: String?) -> CJBaseImageModel {
        var newImageModel = self
        newImageModel.imageColorString = colorString
        return newImageModel
    }
}

public struct CJFontIcon: View {
    var fontModel: CJBaseDataModel
    var isSelected: Bool
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center){
               Image(fontModel.egImage)
                    .resizable()
                    .renderingMode(isSelected ? .template : nil) // 将图片设置为模板模式
                    .foregroundColor(isSelected ? Color.white : nil)
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(isSelected ? nil : Color(hex: "#2E2E2E"))
            .cornerRadius(15)
        }
    }
}
