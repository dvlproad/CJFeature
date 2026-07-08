//
//  TSMyWidgetHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CQWidgetBundleCommon

struct TSMyWidgetHomePage: View {
    @State private var items: [BaseControlWidgetEntity] = []
    
    var body: some View {
        VStack {
            TSControlWidgetGridView(items: items, pageType: .myWidgetPage)
                .navigationTitle("我的组件Demo")
        }
        .onAppear() {
            items = TSWidgetBundleCacheUtil.getControlWidgets(.all)
        }
    }
}

struct TSControlWidgetGridView: View {
    let items: [BaseControlWidgetEntity]
    let pageType: CCPageType
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    NavigationLink(
                        destination: TSControlWidgetDetailPage(fromPageType: pageType, entity: item),
                        label: {
                            BaseControlWidgetViewInApp(
                                entity: item,
                                pageInfo: CCPageInfo(pageType: pageType)
                            )
                            .frame(height: 60)
                        }
                    )
                }
            }
        }
    }
}
