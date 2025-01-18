//
//  QuickStartInputView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import SwiftUI
import CJViewElement_Swift

struct QuickStartInputView: View {
//    @Binding var currentSegmentIndex: Int
    @Binding var appModel: QuickStartAppModel?
    @Binding var shortcutsModel: QuickStartShortcutsModel?
    @Binding var webModel: QuickStartWebModel?
    
    let options: [BaseSegmentModel]
    @Binding var currentSegmentModel: BaseSegmentModel?
    var onChangeOfExecModel: ((_ newSegmentModel: BaseSegmentModel?, _ newAppModel: QuickStartAppModel?, _ newShortcutsModel: QuickStartShortcutsModel?, _ newWebModel: QuickStartWebModel?) -> Void)
    
    private func onValueChange() {
//        let currentSegmentIndex = options.firstIndex(where: { $0.segmentId == currentSegmentModel?.segmentId }) ?? 0
        onChangeOfExecModel(currentSegmentModel, appModel, shortcutsModel, webModel)
    }
    
    @State private var showAppList: Bool = false
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 10) {
                CustomSegmentView(
                    options: options,
                    currentSelectedModel: $currentSegmentModel,
                    height: 32.0,
                    onChangeOfModel: { option in
                        currentSegmentModel = option
                        
                        onValueChange()
                    }
                )
                
                let textFieldHeight = 40.0
                VStack(alignment: .center, spacing: 0) {
                    let currentSegmentIndex = options.firstIndex(where: { $0.segmentId == currentSegmentModel?.segmentId }) ?? 0
                    if currentSegmentIndex == 1 {
                        let appName = appModel?.appName ?? "请选择"
                        
                        TitleRowView(title: "选择快捷启动", bindingValue: .constant(appName), onTapValue: {
                            //showAnimationSheet.toggle()
                            showAppList = true
                        })
                        .frame(height: 30)
                        .padding(.horizontal, 10)
                        
                        // 跳转到新页面
                        NavigationLink(isActive: $showAppList) {
                            QuickStartAppListView(
                                selectedApp: { newAppModel in
                                    appModel = newAppModel
                                    onValueChange()
                                }
                            )
                        } label: {
                        }
                        
                    } else if currentSegmentIndex == 2 {
                        let bindingValue = Binding(
                            get: { shortcutsModel?.shortcutsName ?? "" },
                            set: { newValue in
                                let encodeShortcutsName = newValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                let shortcutsUrl = "shortcuts://run-shortcut?name=\(encodeShortcutsName ?? "")"
                                
                                if shortcutsModel == nil {
                                    shortcutsModel = QuickStartShortcutsModel(shortcutsName: newValue, targetUrl: shortcutsUrl)
                                } else {
                                    shortcutsModel!.shortcutsName = newValue
                                    shortcutsModel!.targetUrl = shortcutsUrl
                                }
                            }
                        )
                        
                        CJTextSettingRow(
                            title: "指令名称",
                            text: bindingValue,
                            placeHolder: "请输入文案",
                            lineLimit: 1,
                            textFieldHeight: textFieldHeight,
                            textDidChange: { value in
                                let encodeShortcutsName = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                                let shortcutsUrl = "shortcuts://run-shortcut?name=\(encodeShortcutsName ?? "")"
                                let shortcutsUrl = "name=\(encodeShortcutsName ?? "")"
                                shortcutsModel = QuickStartShortcutsModel(shortcutsName: value, targetUrl: shortcutsUrl)
                                
                                onValueChange()
                            }
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        

                        CJTextSettingRow(
                            title: "网址",
                            text: .constant(shortcutsModel?.targetUrl ?? ""),
                            placeHolder: "请输入你想要跳转的网址",
                            isEditable: false,
                            lineLimit: 1,
                            textFieldHeight: textFieldHeight,
                            textDidChange: { value in
                                // do nothing
                            }
                        )
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        
                        HStack(alignment: .center, spacing: 0) {
                            Text("测试运行")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.blue)
                        }
                        .onTapGesture {
                            if let shortcutsUrl = shortcutsModel?.targetUrl, let shortcutsURL = URL(string: shortcutsUrl) {
                                if UIApplication.shared.canOpenURL(shortcutsURL) {
                                    UIApplication.shared.open(shortcutsURL, options: [:], completionHandler: nil)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                    } else if currentSegmentIndex == 3 {
                        let bindingValue = Binding(
                            get: { webModel?.targetUrl ?? "" },
                            set: { newValue in
                                if webModel == nil {
                                    webModel = QuickStartWebModel(name: "", targetUrl: newValue)
                                } else {
                                    webModel!.targetUrl = newValue
                                }
                            }
                        )
                        CJTextSettingRow(
                            title: "网址",
                            text: bindingValue,
                            placeHolder: "请输入你想要跳转的网址",
                            lineLimit: 1,
                            textFieldHeight: textFieldHeight,
                            textDidChange: { value in
                                webModel = QuickStartWebModel(name: "", targetUrl: value)
                                
                                onValueChange()
                            }
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        
                    } else {
                        Text("点击控制项时，不会跳转/打开任何内容")
                            .foregroundColor(Color.black)
                            .font(.system(size: 16, weight: .regular))
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width, height: 30)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#EEEEEE"), lineWidth: 1)
                )
            }
        }
        .onAppear() {
//            if let appModel = appModel {
//                currentSegmentModel = options[1]
//            } else if let shortcutsModel = shortcutsModel {
//                currentSegmentModel = options[2]
//            } else if let webModel = webModel {
//                currentSegmentModel = options[3]
//            } else {
//                currentSegmentModel = options[0]
//            }
        }
        
    }
    
    var appInputView: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("选择快捷启动")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Text("快捷指令")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            Text(" >")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
        }
    }
}
