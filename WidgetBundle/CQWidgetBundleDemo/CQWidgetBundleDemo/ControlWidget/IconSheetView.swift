//
//  IconSheetView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI
import CQWidgetBundleCommon

public struct IconSheetView: View {
    @State private var options: [IconModuleModel]
    @State var selectedIndex: Int           // 不用 bind ，为了选择结束后能恢复原值
    var onChangeOfIndex: (Int) -> Void
    
    public init(options: [IconModuleModel], selectedIndex: Int, onChangeOfIndex: @escaping (Int) -> Void) {
        self.options = options
        self.selectedIndex = selectedIndex
        self.onChangeOfIndex = onChangeOfIndex
    }
    
    public var body: some View {
        GeometryReader(content: { geometry in
            ControlWidgetIconGridView(
                imageModels: options[0].options,
                selectedImageId: .constant("//TODO:qian"),
                contentHeight: .constant(geometry.size.height),
                onTap: {
                    onChangeOfIndex(selectedIndex)
                }
            )
        })
        
//        Spacer()
    }
}


public struct IconModuleModel {
    var name: String
    var options: [CJBaseImageModel]
}

struct ControlWidgetIconGridView: View {
    var imageModels: [CJBaseImageModel]
    @Binding var selectedImageId: String
    @Binding var contentHeight: CGFloat
    var onTap: (() -> Void)
    
    func gridItems(_ count: Int, width: CGFloat, spacing: CGFloat) -> [GridItem] {
        var gridItems: [GridItem] = []
        for _ in 0..<count {
            gridItems.append(GridItem(.fixed(width), spacing: spacing))
        }
        return gridItems
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let countPerRow: Int = 5
            let spacing: CGFloat = 12.5
            let row: Int = (imageModels.count - 1) / countPerRow + 1
            let spacings: CGFloat = CGFloat((countPerRow - 1)) * spacing
            let width: CGFloat = (geometry.size.width - 3 - spacings) / CGFloat(countPerRow)
            let height: CGFloat = (width + spacing) * CGFloat(row)
            let gridItems = gridItems(countPerRow, width: width, spacing: spacing)
            LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(0..<imageModels.count, id:\.self) { index in
                    // BaseControlWidgetAnimationView
                    let imageModel = imageModels[index]
                    ControlWidgetIconGridCell(
                        imageModel: imageModel,
                        isSelected: .constant(imageModel.id == selectedImageId)
                    )
                    .frame(width: width, height: width)
                    .onTapGesture {
                        selectedImageId = imageModel.id
                        onTap()
                    }
                    
                }
            }
            .background(Color.white)
            .frame(height: height)
            .onAppear {
                contentHeight = height + 30
            }
        })
    }
}


struct ControlWidgetIconGridCell: View {
    var imageModel: CJBaseImageModel
    @Binding var isSelected: Bool
    
    var body: some View {
        GeometryReader { geometry in
            
            let imageSize = CGSize(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
            let cornerRadius = 10.0
            ZStack(alignment: .center) {
                // 背景色和圆角
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(hex: "#2E2E2E"))
                
                let imageView = imageModel.createImageView()
                //let imageView = Image("quickStart_default_1")
                imageView
                    .resizable()
                    .imageFrame(imageSize)
                    .aspectRatio(contentMode: .fit)
            }
            .overlay(
                // 动态边框
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        Color(hex: "#2E2E2E"),
                        lineWidth: isSelected ? 1.5 : 0
                    )
            )
        }
    }
}
