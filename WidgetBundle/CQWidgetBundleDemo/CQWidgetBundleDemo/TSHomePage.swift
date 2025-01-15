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
            /*
            CQControlWidgetHomeViewControllerRepresentable(
                onTapEntity: { entity in
                    isDetailViewActive = true // 设置状态为 true，触发跳转
                    selectedData = entity
                }
            )
            .frame(height: UIScreen.main.bounds.height-200)
            .clipped()
            // 隐式的 NavigationLink，配合状态控制跳转
            NavigationLink(
                destination: TSControlWidgetDetailPage(fromPageType: .homePage, entity: self.selectedData),
                isActive: $isDetailViewActive, // 绑定状态
                label: { EmptyView() } // 空视图，不显示 NavigationLink 的样式
            )
            */
            //*
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
                        imageAnimateType: .none,
                        name: "",
                        widgetStyle: .circle,
                        bgColorString: "#ff0000"
                    )
                    items.append(newItem)
                }) {
                    Text("Add Item")
                }
            }
            //*/
            NavigationLink(destination: TSCustomSymbolPage()) {
                Text("测试自定义Symbol")
            }
            NavigationLink(destination: TSEasyAnimationView()) {
                Text("测试动画")
            }
            NavigationLink(destination: TSGifPage()) {
                Text("测试Gif")
            }
            // 测试快捷启动的按钮
            Button(action: {
                let appUrl = "calshow://"   // 日历
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动：日历（模拟器就有）")
            }
            
            Button(action: {
                let appUrl = "shortcuts://"     // 快捷指令
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动：快捷指令首页（模拟器就有）")
            }
            
            Button(action: {
                // "shortcuts://run-shortcut?name=[名称]&input=[输入]&text=[文本]"
                let shortcutsName = "添加新提醒事项"
                let shortcutsText = "Open List"
                let appUrl = "shortcuts://run-shortcut?name=\(shortcutsName)&input=text&text=\(shortcutsName)"
//                let appUrl = "shortcuts://run-shortcut?name=Lookup%20Goetta&input=text&text=goetta%20is%20great"
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动：快捷指令指定（模拟器就有）")
            }
            
            Button(action: {
                let appUrl = "mobilenotes://"   // 备忘录
                if let url = URL(string: appUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("测试快捷启动:备忘录(真机才有）")
            }
            
            
            Button(action: {
                if let savePath = TSWidgetResourceCacheUtil.copyImageToSharedDirectory(
                    imageName: "emoji9_FFA5BE_byPath",
                    imageExtension: "svg"
                ) {
                    CJTestUtil.sfsymbolPath_inShareDir = savePath
                    CJLogUtil.log("文件保存到的路径是:\(savePath)")
                } else {
                    CJLogUtil.log("文件保存失败")
                }
                
            }) {
                Text("测试加载共享资源目录中的 SF Symbol 图标")
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
