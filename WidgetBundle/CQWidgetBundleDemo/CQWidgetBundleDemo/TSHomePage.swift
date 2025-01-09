//
//  TSHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI

struct TSHomePage: View {
    @State var isReAppear: Bool = false
    @State private var items: [BaseControlWidgetEntity] = []
    
    var body: some View {
        NavigationStack {
            // 右上角有个按钮"我的组件"
            HStack {
                Spacer()
                NavigationLink(destination: TSMyWidgetHomePage()) {
                    Text("我的组件")
                }
            }
            
            VStack {
                // 使用数组的索引来作为List的标识符
                List(items.indices, id: \.self) { index in
                    let item = items[index]
                    NavigationLink(destination: TSControlWidgetDetailPage(entity: item)) {
                        BaseControlWidgetView(entity: item)
                    }
                }
                .navigationTitle("控制中心组件")
                
                // 按钮用于创建新的数据项并更新列表
                Button(action: {
                    let newItem = BaseControlWidgetEntity(id: "id_\(items.count + 1)", uuid: "uuid_\(items.count + 1)", title: "样式\(items.count + 1)")
                    items.append(newItem)
                }) {
                    Text("Add Item")
                }
            }
        }
        .onAppear() {
            if !isReAppear {
                isReAppear = true
                self.viewDidLoad()
            }
        }
    }
    
    func viewDidLoad() {
        // 创建20个item
        for _ in 1...20 {
            let newItem = BaseControlWidgetEntity(id: "id_\(items.count + 1)", uuid: "uuid_\(items.count + 1)", title: "样式\(items.count + 1)")
            items.append(newItem)
        }
    }
}
