//
//  TSMyWidgetHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI

struct TSMyWidgetHomePage: View {
    @State private var items: [BaseControlWidgetEntity] = []
    
    var body: some View {
        VStack {
            // 使用数组的索引来作为List的标识符
            List(items.indices, id: \.self) { index in
                let item = items[index]
                NavigationLink(destination: TSControlWidgetDetailPage(entity: item)) {
                    BaseControlWidgetView(entity: item)
                }
            }
            .navigationTitle("我的组件")
        }
        .onAppear() {
            items = TSWidgetBunldeCacheUtil.getControlWidgets()
        }
    }
}
