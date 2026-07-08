//
//  IconCollectionView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//


import SwiftUI
import AppIntents
import CQWidgetBundleCommon

public struct BaseIconsScrollView<CellView: View, HeaderView: View, BottomView: View, TModel: Identifiable>: View {
    //let axes: Axis.Set
    var direction: Axis.Set // 用来设置滚动方向，支持水平和竖直
    let cellItemSpacing: CGFloat    // item 之间的间隔
    let cellSizeForIndex:  (_ index: Int) -> (width: CGFloat?, height: CGFloat?)
    let cellViewGetter: (_ dataModel: TModel, _ isSelected: Bool, _ tapModelHandler: @escaping () -> Void) -> CellView
    
    var maxCount: Int?
    var headerView: (() -> HeaderView)?  // 头部视图
    var bottomView: (() -> BottomView)?   // 尾部视图
    
    var dataModels: [TModel]
    @Binding var selectedIds: [TModel.ID]
    var tapCountSupportMultiple: Bool // 是否支持多选(如果是单选，则添加前需要先清空选中的数组)
    var tapAgainShouldCancle: Bool  // 重复是否应该取消之前选中
    var allowTapSelf: Bool
    var onTapDataModelComplete: ((_ lastTapDataModel: TModel, _ newSelectedIds: [TModel.ID]) -> Void)?
    
    @State private var selectedIndex: Int?  // 最后一次点击的位置（如果是多选也只会记录最后一次）
    
    /// 单选视图
    public init(direction: Axis.Set,
                cellItemSpacing: CGFloat,
                // cell 的 width / height 返回nil，则会自适应父视图大小
                cellSizeForIndex: @escaping (_ index: Int) -> (width: CGFloat?, height: CGFloat?),
                cellViewGetter: @escaping (_ dataModel: TModel, _ isSelected: Bool, _ tapModelHandler: @escaping () -> Void) -> CellView, // 让外部(如cell内的checkBox)也可以触发 tapModel
                
                maxCount: Int? = nil,
                headerView: (() -> HeaderView)? = { EmptyView() }, // 不设置时，设为 EmptyView ，以让程序可推断出 HeaderView
                bottomView: (() -> BottomView)? = { EmptyView() },
                
                dataModels: [TModel],
                
                selectedDataModel: Binding<TModel?> = .constant(nil),
                tapAgainShouldCancle: Bool,
                allowTapSelf: Bool = true, // 默认true,允许点击自身。一些当只有点击cell上的某些按钮才能触发点击事件的，应该将此值设为false
                onTapDataModelComplete: ((_ lastTapDataModel: TModel) -> Void)? = nil
    ) {
        let bindingValue = Binding<[TModel.ID]>(
            get: {
                if let selectedId = selectedDataModel.wrappedValue?.id {
                    return [selectedId]
                }
                return []
            },
            set: { newIds in
//                去掉 set 的执行内容，避免在详情页中切换控制项的时候得到的 oldEditIndex 是新的
//                if let firstId = newIds.first {
//                    if let model = dataModels.first(where: { $0.id == firstId }) {
//                        selectedDataModel.wrappedValue = model
//                    }
//                } else {
//                    selectedDataModel.wrappedValue = nil
//                }
            }
        )
        
        self.init(direction: direction,
                  cellItemSpacing: cellItemSpacing,
                  cellSizeForIndex: cellSizeForIndex,
                  cellViewGetter: cellViewGetter,
                  maxCount: maxCount,
                  headerView: headerView,
                  bottomView: bottomView,
                  dataModels: dataModels,
                  selectedIds: bindingValue,
                  tapCountSupportMultiple: false,
                  tapAgainShouldCancle: tapAgainShouldCancle,
                  allowTapSelf: allowTapSelf,
                  onTapDataModelComplete: { lastTapDataModel, newSelectedIds in
                    onTapDataModelComplete?(lastTapDataModel)
                  }
        )
    }
    
    /// 多选视图
    public init(direction: Axis.Set,
                cellItemSpacing: CGFloat,
                // cell 的 width / height 返回nil，则会自适应父视图大小
                cellSizeForIndex: @escaping (_ index: Int) -> (width: CGFloat?, height: CGFloat?),
                cellViewGetter: @escaping (_ dataModel: TModel, _ isSelected: Bool, _ tapModelHandler: @escaping () -> Void) -> CellView,
                
                maxCount: Int? = nil,
                headerView: (() -> HeaderView)? = { EmptyView() }, // 不设置时，设为 EmptyView ，以让程序可推断出 HeaderView
                bottomView: (() -> BottomView)? = { EmptyView() },
                
                dataModels: [TModel],
                
                selectedIds: Binding<[TModel.ID]> = .constant([]),
                tapCountSupportMultiple: Bool,
                tapAgainShouldCancle: Bool,
                allowTapSelf: Bool = true, // 默认true,允许点击自身。一些当只有点击cell上的某些按钮才能触发点击事件的，应该将此值设为false
                onTapDataModelComplete: ((_ lastTapDataModel: TModel, _ newSelectedIds: [TModel.ID]) -> Void)? = nil
    ) {
        self.direction = direction
        
        self.cellItemSpacing = cellItemSpacing
        self.cellSizeForIndex = cellSizeForIndex
        self.cellViewGetter = cellViewGetter
        
        self.maxCount = maxCount
        self.headerView = headerView
        self.bottomView = bottomView
        
        self.dataModels = dataModels
        
        self._selectedIds = selectedIds
        self.tapCountSupportMultiple = tapCountSupportMultiple
        self.tapAgainShouldCancle = tapAgainShouldCancle
        self.allowTapSelf = allowTapSelf
        self.onTapDataModelComplete = onTapDataModelComplete
    }
    
    // MARK: View
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(direction, showsIndicators: false) {
                if direction == .vertical {
                    LazyVStack(spacing: cellItemSpacing) {
                        buildItems()
                    }
                } else {
                    LazyHStack(spacing: cellItemSpacing) {
                        buildItems()
                    }
                }
            }
            .onChange(of: selectedIndex) { newValue in
                withAnimation {
                    if let index = newValue {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
            .onAppear() {
                selectedIndex = dataModels.firstIndex(where: {
                    self.selectedIds.contains($0.id)
                }) ?? -1
                withAnimation {
                    if let index = selectedIndex {
                        scrollView.scrollTo(index, anchor: .center)
                    }
                }
            }
        }
    }
    
    // 处理视图项目的生成
    // 用 Group 来包裹不同的视图元素。这样可以根据滚动方向（direction）动态选择合适的布局容器（LazyVStack 或 LazyHStack）。
    private func buildItems() -> some View {
        Group {
            if let headerView: HeaderView = headerView?() {
                headerView
            }
            
            let itemCount = dataModels.count
            let showCount = maxCount != nil ? min(maxCount!, itemCount) : itemCount
            ForEach(0..<showCount, id:\.self) { index in
                let model = dataModels[index]
//                let showItems = dataModels.prefix(showCount) // 截取最多 showCount 个元素
//                ForEach(Array(showItems.enumerated()), id: \.offset) { index, model in
                let cellSize = cellSizeForIndex(index)
                let cellView: CellView = cellViewGetter(model, selectedIds.contains(model.id), {
                    tapModel(index, model: model)  // 让外部(如cell内的checkBox)也可以触发 tapModel
                })
                cellView
                    .frame(width: cellSize.width, height: cellSize.height)
                    //.background(Color.randomColor)
                    .contentShape(Rectangle()) // 确保整个区域响应手势，修复点击cell上无内容的部分会无法触发 onTapGesture
                    .onTapGesture {
                        if allowTapSelf {
                            tapModel(index, model: model)
                        }
                    }
                    .id(index)
            }
            
            if let bottomView: BottomView = bottomView?() {
                if let maxCount = maxCount, itemCount > maxCount {
                    bottomView
                }
            }
        }
    }
    
    // MARK: Event
    private func tapModel(_ index: Int, model: TModel) {
        selectedIds = SelectUtil.updateSelectedIds(
            selectedIds,
            currentTapId: model.id,
            tapAgainShouldCancle: tapAgainShouldCancle,
            tapCountSupportMultiple: tapCountSupportMultiple
        )
        
        selectedIndex = dataModels.firstIndex(where: { $0.id == model.id }) ?? -1
        
        onTapDataModelComplete?(model, selectedIds)
    }
}

public struct SelectUtil {
    // 静态方法，用于更新选中的 ID 数组
    static func updateSelectedIds<ID: Equatable>(
        _ selectedIds: [ID],               // 当前选中的 ID 数组
        currentTapId: ID,                // 当前点击的模型 ID
        tapAgainShouldCancle: Bool,      // 点击后是否取消选中
        tapCountSupportMultiple: Bool   // 是否支持多选
    ) -> [ID] {
        var updatedSelectedIds = selectedIds

        if tapAgainShouldCancle {
            if updatedSelectedIds.contains(currentTapId) {
                updatedSelectedIds.removeAll(where: { $0 == currentTapId })
            } else {
                if !tapCountSupportMultiple {
                    updatedSelectedIds.removeAll()
                }
                updatedSelectedIds.append(currentTapId)
            }
        } else {
            if !updatedSelectedIds.contains(currentTapId) {
                if !tapCountSupportMultiple {
                    updatedSelectedIds.removeAll()
                }
                updatedSelectedIds.append(currentTapId)
            }
        }

        debugPrint("当前选中的ids为:\(updatedSelectedIds)")
        return updatedSelectedIds
    }
}


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

//#Preview {
//    CJFontIcon(fontModel: CJBaseDataModel(name: "fontImage_6", egImage: "fontImage_6"), isSelected: false)
//}
