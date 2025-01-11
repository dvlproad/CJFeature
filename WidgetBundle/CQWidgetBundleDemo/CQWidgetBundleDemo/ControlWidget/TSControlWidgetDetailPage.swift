//
//  TSControlWidgetDetailPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift
import WidgetKit

struct TSControlWidgetDetailPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    var fromPageType: CQPageType
    @State var entity: BaseControlWidgetEntity
    
    @State private var showAnimationSheet: Bool = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(entity.id)当前数据为: \(entity.title)")
                //BaseControlWidgetView(entity: entity)
                BaseControlWidgetView(bindingEntity: $entity)
                Spacer(minLength: 20)

                List {
                    let textFieldWidth = 320.0
                    let textFieldHeight = 40.0
                    CJTextSettingRow(
                        title: entity.title,
                        text: Binding(get: { entity.title }, set: { entity.title = $0 }),
                        placeHolder: "请输入内容",
                        lineLimit: 1,
                        textFieldWidth: textFieldWidth,
                        textFieldHeight: textFieldHeight,
                        textDidChange: { value in
                            entity.title = value
//                            self.updateUI()
                        }
                    )
                    .padding(.horizontal, 21)
                    
                    CJTextSettingRow(
                        title: entity.subTitle,
                        text: Binding(get: { entity.subTitle }, set: { entity.subTitle = $0 }),
                        placeHolder: "请输入内容",
                        lineLimit: 1,
                        textFieldWidth: textFieldWidth,
                        textFieldHeight: textFieldHeight,
                        textDidChange: { value in
                            entity.subTitle = value
//                            self.updateUI()
                        }
                    )
                    .padding(.horizontal, 21)
                    
                    Button(action: {
                        entity.animateModel.isAnimating = true
                        showAnimationSheet.toggle()
                    }) {
                        Text("选择动画:\(entity.animateModel.type.description)")
                    }
                }
                
                ZStack {
                    Button("保存组件") {
                        if let saveId = entity.saveId, saveId.count > 0 {
                            TSWidgetBundleCacheUtil.updateControlWidgetEntity(entity, shouldRefreshDesktop: true)
                            
                            if #available(iOS 18.0, *) {
                                ControlCenter.shared.reloadControls(
                                    ofKind: "com.cqWidgetBundleDemo.toggle" //BaseControlWidget.kind
                                )
                            } else {
                                // Fallback on earlier versions
                            }
                        } else {
                            entity.saveId = UUID().uuidString
                            TSWidgetBundleCacheUtil.addControlWidgetEntity(entity)
                        }
                        
                        
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showAnimationSheet) {
            // 表单内容
            NavigationView {
                Form {
                    Section {
                        // 选项1
                        Button("无动画") {
                            // 选项1的处理逻辑
                            entity.animateModel.type = .none
                            showAnimationSheet = false
                        }
                        // 选项2
                        Button("弹跳") {
                            // 选项2的处理逻辑
                            entity.animateModel.type = .bounce
                            showAnimationSheet = false
                        }
                        // 选项3
                        Button("旋转") {
                            // 选项3的处理逻辑
                            entity.animateModel.type = .rotate
                            showAnimationSheet = false
                        }
                    }
                }
                .navigationBarTitle("选择动画")
            }
        }
        .onAppear() {
            print("TSControlWidgetDetailPage onAppear")
        }
    }

}
