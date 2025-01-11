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
