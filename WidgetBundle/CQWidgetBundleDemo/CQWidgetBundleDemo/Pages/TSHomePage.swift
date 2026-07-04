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
    @State private var selectedData: BaseControlWidgetEntity = BaseControlWidgetEntity.defaultEntityForDesktopType(.toggle)
    
    var body: some View {
        NavigationStack {
            bodyContent
                .onAppear() {
                    if !isReAppear {
                        isReAppear = true
                        self.viewDidLoad()
                    }
                    
                    cacheItems = TSWidgetBundleCacheUtil.getControlWidgets(.all)
                }
        }
        
    }
    
    
    
    var bodyContent: some View {
        VStack {
            // 右上角有个按钮"我的组件"
            HStack {
                NavigationLink(destination: TSMyWidgetHomePage()) {
                    Text("我的组件Demo(\(cacheItems.count))")
                }
                
                Spacer()
                
                NavigationLink(
                    destination: CQControlWidgetMyViewRepresentable(
                        onTapEntity: { [self] entity in
                            CCLogUtil.log("在我的组件点击了组件，正准备跳转：layoutId = \(entity.id)")
                        }
                    ),
                    label:  {
                        Text("我的组件(\(cacheItems.count))")
                    }
                )
            }
            
            // 控制中心首页
            HStack {
                Text("控制中心首页视图Demo")
                    .frame(height: 40)
                    .background(.clear)
                
                Spacer()
                
                NavigationLink(destination: CQControlWidgetHomeViewWrapper()) {
                    Text("控制中心首页视图")
                }
            }
            TSControlWidgetGridView(items: items, pageType: .homePage)
            
//            Text("以下是 CQControlWidgetCollectionViewRepresentable")
//                .frame(height: 40)
//                .background(.red)
//            widgetCollectionView
//                .frame(height: UIScreen.main.bounds.height-400)
//                .clipped()
            
            TSTestHomePage()
        }
    }
    
    @State var collectionViewRefreshUUID: UUID = UUID()
    var widgetCollectionView: some View {
        VStack {
            CQControlWidgetCollectionViewRepresentable(
                dataModels: CQControlWidgetIds.exampleSetsFromJson(),
                onTapEntity: { entity in
                    collectionViewRefreshUUID = UUID()
                    selectedData = entity.entitys.first!
                    isDetailViewActive = true // 设置状态为 true，触发跳转
                }
            )
            /*
            // 隐式的 NavigationLink，配合状态控制跳转
            NavigationLink(
                destination: TSControlWidgetDetailPage(fromPageType: .homePage, entity: self.selectedData),
                isActive: $isDetailViewActive, // 绑定状态
                label: { EmptyView() } // 空视图，不显示 NavigationLink 的样式
            )
            //.id(collectionViewRefreshUUID)
            */
        }
//        .navigationDestination(for: BaseControlWidgetEntity.self) { selectedData in
//            TSControlWidgetDetailPage(fromPageType: .homePage, entity: self.selectedData)
//        }
    }
    
    
    func viewDidLoad() {
        items = CQControlWidgetIds.examples()
    }
}
