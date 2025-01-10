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
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(entity.id)当前数据为: \(entity.title)")
                BaseControlWidgetView(entity: entity)

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
                }
                
                ZStack {
                    Button("保存组件") {
                        if let saveId = entity.saveId, saveId.count > 0 {
                            TSWidgetBundleCacheUtil.updateControlWidgetEntity(entity)
                        } else {
                            entity.saveId = UUID().uuidString
                            TSWidgetBundleCacheUtil.addControlWidgetEntity(entity)
                        }
                        
                        if #available(iOS 18.0, *) {
                            ControlCenter.shared.reloadControls(
                                ofKind: "com.cqWidgetBundleDemo.toggle" //BaseControlWidget.kind
                            )
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear() {
            print("TSControlWidgetDetailPage onAppear")
        }
    }

}
