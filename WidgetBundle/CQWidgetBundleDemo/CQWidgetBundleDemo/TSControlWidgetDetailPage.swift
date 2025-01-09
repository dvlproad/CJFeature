//
//  TSControlWidgetDetailPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI

struct TSControlWidgetDetailPage: View {
    @State var entity: BaseControlWidgetEntity
    
    var body: some View {
        NavigationView {
            VStack {
                Text("当前数据为: \(entity.title ?? "无数据")")
                

                List {
                    Button("变更标题：样式1") {
                        entity.title = "样式1"
                    }
                    Button("变更标题：样式2") {
                        entity.title = "样式2"   
                    }
                }
                
                ZStack {
                    Button("保存组件") {
                        TSWidgetBunldeCacheUtil.addControlWidgetEntity(entity)
                    }
                }
            }
        }
        .onAppear() {
            print("TSControlWidgetDetailPage onAppear")
        }
    }

}
