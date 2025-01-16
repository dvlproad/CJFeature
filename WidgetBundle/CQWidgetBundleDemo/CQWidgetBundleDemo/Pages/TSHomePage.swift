//
//  TSHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift

struct TSHomePage: View {
    @State var isReAppear: Bool = false
    @State private var items: [BaseControlWidgetEntity] = []
    @State private var cacheItems: [BaseControlWidgetEntity] = []
    
    @State private var isDetailViewActive = false // 控制跳转的状态
    @State private var selectedData: BaseControlWidgetEntity = BaseControlWidgetEntity.nilEntity()
    
    var body: some View {
        NavigationStack {
            bodyContent
                .onAppear() {
                    if !isReAppear {
                        isReAppear = true
                        self.viewDidLoad()
                    }
                    
                    cacheItems = TSWidgetBundleCacheUtil.getControlWidgets()
                }
        }
        
    }
    
    
    
    var bodyContent: some View {
        VStack {
            // 右上角有个按钮"我的组件"
            HStack {
                Spacer()
                NavigationLink(destination: TSMyWidgetHomePage()) {
                    Text("我的组件(\(cacheItems.count))")
                }
            }
            
            widgetTableView
            
//            widgetCollectionView
//                .frame(height: UIScreen.main.bounds.height-400)
//                .clipped()
            
            TSTestHomePage()

            
        }
    }
    
    @State var collectionViewRefreshUUID: UUID = UUID()
    var dataModels: [BaseControlWidgetEntity] = CQControlWidgetIds.examples()
    var widgetCollectionView: some View {
        VStack {
            //CQControlWidgetCollectionViewRepresentable {
            CQControlWidgetCollectionViewRepresentable(
                dataModels: dataModels,
                onTapEntity: { entity in
                    collectionViewRefreshUUID = UUID()
                    selectedData = entity
                    isDetailViewActive = true // 设置状态为 true，触发跳转
                }
            )
            // 隐式的 NavigationLink，配合状态控制跳转
            NavigationLink(
                destination: TSControlWidgetDetailPage(fromPageType: .homePage, entity: self.selectedData),
                isActive: $isDetailViewActive, // 绑定状态
                label: { EmptyView() } // 空视图，不显示 NavigationLink 的样式
            )
            //.id(collectionViewRefreshUUID)
        }
//        .navigationDestination(for: BaseControlWidgetEntity.self) { selectedData in
//            TSControlWidgetDetailPage(fromPageType: .homePage, entity: self.selectedData)
//        }
    }
    
    var widgetTableView: some View {
        // 使用数组的索引来作为List的标识符
        List(items.indices, id: \.self) { index in
            let item = items[index]
            NavigationLink(destination: TSControlWidgetDetailPage(fromPageType: .homePage, entity: item)) {
                BaseControlWidgetView(entity: item)
            }
        }
        .navigationTitle("控制中心组件")
    }
    
    
    func viewDidLoad() {
        items = CQControlWidgetIds.examples()
    }
}
