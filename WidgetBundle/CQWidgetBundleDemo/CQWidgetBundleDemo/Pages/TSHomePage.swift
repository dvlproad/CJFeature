//
//  TSHomePage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift
import CQWidgetBundleCommon
import CQWidgetBundle

/*
// 跳转的处理：1. 定义通知
extension Notification.Name {
    // 单个组件：从预览进详情
    static let controlWidgetDetailByPreviewModel = Notification.Name("controlWidgetDetailByPreviewModel")
    
    
    
    // 组件套： 从预览进组件列表
    static let controlWidgetGroupListBySet = Notification.Name("controlWidgetGroupListBySet")
    static let controlWidgetGroupByPreviewModel = Notification.Name("controlWidgetGroupByPreviewModel")
}
*/

struct TSHomePage: View {
    /*
    // 跳转的处理：3.1. 顶层监听通知
    @State private var showDetail = false
    @State private var groupModel: BaseControlWidgetSetModel?
    @State private var previewModel: ControlWidgetPreviewModel?
    */
    
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
                /*
                // 跳转的处理：3.2. 顶层监听通知
                .onReceive(NotificationCenter.default.publisher(for: .controlWidgetGroupListBySet)) { notification in
                    if let entitySet = notification.userInfo?["entitySet"] as? BaseControlWidgetSetModel {
                        groupModel = entitySet
                        showDetail = true
                    }
                }
                .navigationDestination(isPresented: $showDetail) { // 这是以模态方式弹出，不是 push，点击系统导航栏会关闭所有的页面，而不是到上一级页面
                    if let groupModel = groupModel {
                        let count = groupModel.entitys.count
                        if count > 1 { // 组件套： 从预览进组件列表
                            TSControlWidgetGroupPage(fromPageType: .homePage, groupModel: groupModel)
                        } else {
                            TSControlWidgetDetailPage(fromPageType: .homePage, setModel: groupModel)
                        }
                    }
                }
                */
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
