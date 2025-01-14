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
            
            CQControlWidgetHomeViewControllerRepresentable(
                onTapEntity: { entity in
                    isDetailViewActive = true // 设置状态为 true，触发跳转
                    selectedData = entity
                }
            )
            .frame(height: UIScreen.main.bounds.height-200)
            .clipped()
            
//            if let entity = self.selectedData {
                // 隐式的 NavigationLink，配合状态控制跳转
                NavigationLink(
                    destination: TSControlWidgetDetailPage(fromPageType: .homePage, entity: self.selectedData),
                    isActive: $isDetailViewActive, // 绑定状态
                    label: { EmptyView() } // 空视图，不显示 NavigationLink 的样式
                )
//            }
            /*
            VStack {
                // 使用数组的索引来作为List的标识符
                List(items.indices, id: \.self) { index in
                    let item = items[index]
                    NavigationLink(destination: TSControlWidgetDetailPage(fromPageType: .homePage, entity: item)) {
                        BaseControlWidgetView(entity: item)
                    }
                }
                .navigationTitle("控制中心组件")
                
                // 按钮用于创建新的数据项并更新列表
                Button(action: {
                    let itemNo = items.count + 1
                    let imageName = imageNames.randomElement()!
                    let newItem = BaseControlWidgetEntity(
                        id: "id_\(itemNo)",
                        uuid: "uuid_\(itemNo)",
                        title: "样式\(itemNo)",
                        subTitle: "组件类型",
                        imageName: imageName,
                        imageAnimateType: .none
                    )
                    items.append(newItem)
                }) {
                    Text("Add Item")
                }
            }
            */
            NavigationLink(destination: TSEasyAnimationView()) {
                Text("测试动画")
            }
            NavigationLink(destination: TSGifPage()) {
                Text("测试Gif")
            }
        }
    }
    
    private var imageNames: [String] {
        var imageNames = ["accessibility-human", "activity"]
        for index in 0...6 {
            imageNames.append("icon_control_katong_\(index%7 + 1)")
        }
        return imageNames
    }
    
    func viewDidLoad() {
        items = CQControlWidgetIds.examples()
    }
}
