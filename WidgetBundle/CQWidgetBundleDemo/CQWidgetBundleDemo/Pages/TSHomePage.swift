//
//  TSHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift
import CQWidgetBundleCommon

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
                    
                    cacheItems = TSWidgetBundleCacheUtil.getControlWidgets(.all)
                }
        }
    }
    
    func viewDidLoad() {
        items = CQControlWidgetIds.examples()
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
            
            TSTestHomePage()
        }
    }
}
