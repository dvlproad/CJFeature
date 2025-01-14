//
//  IconCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//


import SwiftUI

public struct BaseIconsScrollView<CellView: View, HeaderView: View, BottomView: View>: View {
    //let axes: Axis.Set
    let cellItemSpacing: CGFloat    // item 之间的间隔
    let cellSizeForIndex:  (_ index: Int) -> CGSize
    let cellViewGetter: (_ dataModel: CJBaseDataModel, _ isSelected: Bool) -> CellView
    
    var maxCount: Int?
    var headerView: (() -> HeaderView)?  // 头部视图
    var bottomView: (() -> BottomView)?   // 尾部视图
    
    var dataModels: [CJBaseDataModel]
    @State var currentDataModel: CJBaseDataModel?
    var onChangeOfDataModel: ((_ newDataModel: CJBaseDataModel) -> Void)
    
    @State var selectedIndex: Int?
    
    public init(cellItemSpacing: CGFloat,
                cellSizeForIndex: @escaping (_ index: Int) -> CGSize,
                cellViewGetter: @escaping (_ dataModel: CJBaseDataModel, _ isSelected: Bool) -> CellView,
                
                maxCount: Int? = nil,
                headerView: (() -> HeaderView)? = nil,
                bottomView: (() -> BottomView)? = nil,
                
                dataModels: [CJBaseDataModel],
                currentDataModel: CJBaseDataModel?,
                onChangeOfDataModel: @escaping (_: CJBaseDataModel) -> Void
    ) {
        self.cellItemSpacing = cellItemSpacing
        self.cellSizeForIndex = cellSizeForIndex
        self.cellViewGetter = cellViewGetter
        
        self.maxCount = maxCount
        self.headerView = headerView
        self.bottomView = bottomView
        
        self.dataModels = dataModels
        self.currentDataModel = currentDataModel
        self.onChangeOfDataModel = onChangeOfDataModel
    }
    
    // MARK: View
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: cellItemSpacing) {
                    if headerView != nil {
                        headerView!()
                    }
                    
                    let itemCount = dataModels.count
                    let showCount = maxCount != nil ? min(maxCount!, itemCount) : itemCount
                    ForEach(0..<showCount, id:\.self) { index in
                        let model = dataModels[index]
//                    let showItems = dataModels.prefix(showCount) // 截取最多 showCount 个元素
//                    ForEach(Array(showItems.enumerated()), id: \.offset) { index, model in
                        let cellSize = cellSizeForIndex(index)
                        cellViewGetter(model, model.id == currentDataModel?.id)
                            .frame(width: cellSize.width, height: cellSize.height)
                            //.background(Color.randomColor)
                            .onTapGesture {
                                tapModel(index, model: model)
                            }
                            .id(index)
                    }
                    
                    if bottomView != nil {
                        if let maxCount = maxCount, itemCount > maxCount {
                            bottomView!()
                        }
                    }
                }
            }
            .onChange(of: selectedIndex) { oldValue, newValue in
                withAnimation {
                    if let index = newValue {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
            .onAppear() {
                selectedIndex = dataModels.firstIndex(where: { $0.id == currentDataModel?.id }) ?? -1
                withAnimation {
                    if let index = selectedIndex {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
        }
    }
    
    // MARK: Event
    private func tapModel(_ index: Int, model: CJBaseDataModel) {
        currentDataModel = model
        
        selectedIndex = dataModels.firstIndex(where: { $0.id == model.id }) ?? -1
        
        onChangeOfDataModel(model)
    }
}


// MARK: 组件Data数据类
public class CJBaseDataModel: NSObject {
    public var id: String = ""
    public var name: String = ""
    public var egImage: String = ""    // 字体的图片示例
    
    public init(id: String, name: String, egImage: String) {
        self.id = id
        self.name = name
        self.egImage = egImage
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

public struct CJNormalIcon: View {
    var fontModel: CJBaseDataModel
    var isSelected: Bool
    
    public var body: some View {
        let cornerRadius: CGFloat = 10.0
        GeometryReader { geometry in
            ZStack(alignment: .center){
               Image(fontModel.egImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(hex: "#F5F5F5 "))
//            .border(Color.pink, width: isSelected ? 1 : 0)
//            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.pink, lineWidth: isSelected ? 1 : 0)
                )
            // ZStack 的 background 和 border 不会被自动裁剪。这可能导致背景颜色（background) 和边框（border) 显示在圆角之外。
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 裁剪整个区域
        }
    }
}

//#Preview {
//    CJFontIcon(fontModel: CJBaseDataModel(name: "fontImage_6", egImage: "fontImage_6"), isSelected: false)
//}
