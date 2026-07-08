//
//  QuickStartInputView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import SwiftUI
import CJViewElement_Swift
import CQWidgetBundleCommon

struct QuickStartInputView: View {
    let geoWidth: CGFloat
    
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
    
    private var quickStartType: QuickStartType {
        var quickStartType: QuickStartType = .none
        if let typeString = currentSegmentModel?.segmentId {
            quickStartType = QuickStartType(rawValue: typeString) ?? .none
        }
        return quickStartType
    }
    
    @State private var showAppList: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    ControlWidgetTitleRowView(title: "快捷方式")
                    Spacer()
                    
                    CustomSegmentView(
                        options: options,
                        currentSelectedModel: $currentSegmentModel,
                        height: 32.0,
                        onChangeOfModel: { option in
                            currentSegmentModel = option
                            
                            onValueChange()
                        }
                    )
                }
                .padding(.bottom, 15)
                
                let textFieldHeight = 40.0 // 和xingrong确认改成跟外面的标题的大小一样大，虽然会比蓝湖上的36.0大
                VStack(alignment: .center, spacing: 0) {
                    //let currentSegmentIndex = options.firstIndex(where: { $0.segmentId == currentSegmentModel?.segmentId }) ?? 0
                    
                    if quickStartType == .app {
                        let appName = appModel?.appName ?? ""
                        
                        Text(appName)
                            .foregroundColor(Color(hex: "#333333"))
                            .font(.system(size: 14.0, weight: .regular))
                            .withTailingValue(.constant("选择APP"), onTapValue: {
                            //showAnimationSheet.toggle()
                            showAppList = true
                        })
                        .frame(height: textFieldHeight)
                        .withCornerRadius(10.0, horizontalPadding: 10.0)
                        
                        // 跳转到新页面
                        /*
                        NavigationLink(isActive: $showAppList) {
                            QuickStartAppListView(
                                selectedApp: { newAppModel in
                                    appModel = newAppModel
                                    onValueChange()
                                }
                            )
                        } label: {
                        }
                        */
//                        ControlWidgetAppSelectView(
//                            isActive: $showAppList,
//                            type: "3",
//                            onChangeOfApp: { newAppModel in
////                                appModel = newAppModel
//                                appModel = QuickStartAppModel(
//                                    appId: newAppModel.appId,
//                                    appName: newAppModel.appName,
//                                    appShowName: newAppModel.showAppName,
//                                    appIcon: newAppModel.icon,
//                                    targetUrl: newAppModel.iosUri
//                                )
//                                onValueChange()
//                            }
//                        )
                        
                    } else if quickStartType == .shortcuts {
                        let bindingValue = Binding<String>(
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
                        CJTextInputView(
                            text: bindingValue,
                            placeHolder: "请输入文案",
                            multilineTextAlignment: .trailing,
                            lineLimit: 1,
                            textDidChange: { value in
                                let encodeShortcutsName = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                let shortcutsUrl = "shortcuts://run-shortcut?name=\(encodeShortcutsName ?? "")"
                                //let shortcutsUrl = "name=\(encodeShortcutsName ?? "")"
                                shortcutsModel = QuickStartShortcutsModel(shortcutsName: value, targetUrl: shortcutsUrl)
                                
                                onValueChange()
                            }
                        )
                        .withLevelTwoLeadingTitle("指令名称")
                        .withCornerRadius(10.0, horizontalPadding: 10.0)
                        .frame(height: textFieldHeight)

                        CJTextInputView(
                            text: .constant(shortcutsModel?.targetUrl ?? "shortcuts://run-shortcut?name="),
                            placeHolder: "请输入网址",
                            multilineTextAlignment: .trailing,
                            isEditable: false,
                            lineLimit: 1,
                            textDidChange: { value in
                                // do nothing
                            }
                        )
                        .withLevelTwoLeadingTitle("网址")
                        .withCornerRadius(10.0, horizontalPadding: 10.0)
                        .frame(height: textFieldHeight)
                        .padding(.top, 15)
                        
                        HStack(alignment: .center, spacing: 0) {
                            Text("测试运行")
                                .font(.system(size: 13.5, weight: .medium))
                                .foregroundColor(Color(hex: "#333333"))
                                .frame(width: 100, height: 35)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17.5, style: .continuous)
                                        .stroke(Color(hex: "#333333").opacity(1), lineWidth: 1)
                                )
                        }
                        .onTapGesture {
                            if let shortcutsUrl = shortcutsModel?.targetUrl, let shortcutsURL = URL(string: shortcutsUrl) {
                                if UIApplication.shared.canOpenURL(shortcutsURL) {
                                    UIApplication.shared.open(shortcutsURL, options: [:], completionHandler: nil)
                                }
                            } else {
                                TSToastUtil.showMessage("未输入指令名称，无法运行")
                            }
                        }
                        .padding(.top, 20)
                        
                        shortcutsHelpView
                            .padding(.top, 10)
                        
                    } else if quickStartType == .web {
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
                        
                        CJTextInputView(
                            text: bindingValue,
                            placeHolder: "请输入你想要跳转的网址",
                            lineLimit: 1,
                            textDidChange: { value in
                                webModel = QuickStartWebModel(name: "", targetUrl: value)
                                
                                onValueChange()
                            }
                        )
                        .withLevelTwoLeadingTitle("网址")
                        .withCornerRadius(10.0, horizontalPadding: 10.0)
                        .frame(height: textFieldHeight)
                        .padding(.bottom, 10)
                        
                    } else {
                        Text("点击控制项时，不会跳转/打开任何内容")
                            .foregroundColor(Color.black)
                            .font(.system(size: 16, weight: .regular))
                            .multilineTextAlignment(.center)
                            .frame(width: geoWidth, height: 30)
                    }
                }
            }
        }
    }
    
    var shortcutsHelpView: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("请查看")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#333333"))
                Text("快捷指令中心")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .underline()
                    .onTapGesture {
                        QuickStartUtil.openShortcutsApp()
                    }
                Text("，把想添加的快捷指令名称")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#333333"))
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("输入。")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#333333"))
                
                NavigationLink {
                    Text("CCAppConfigManager.quickStartFaqUrl")
//                    WIWebView(url: CCAppConfigManager.quickStartFaqUrl, title: "常见问题").navigationBarHidden(true)
////                        .environmentObject(navigator)
                } label: {
                    Text("了解更多")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#FE4E38"))
                        .underline()
                }
                /*
                Text("了解更多")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .underline()
                    .onTapGesture {
                        TSToastUtil.showTodo("了解更多")
                        let rightView = AnyView(CustomButton(tapComplete: {
                        }, labelView: {
                            NBNavigationLink(value: NavScreen.feedbackVC(0)) {
                                HStack {
                                    Spacer()
                                    Text("反馈")
                                        .font(.system(size: 14.5))
                                        .foregroundColor(Color(hex: "#333333"))
                                    Spacer().frame(width: 19)
                                }
                            }
                        }, bgColor: .clear, radius: 0))
                        let wiWebViewNavModel = WiWebViewNavModel(url: questionsUrl,title: "常见问题",rightView: rightView)
                        NBNavigationLink(value: NavScreen.wiWebView(wiWebViewNavModel)) {
                            HStack(){
                                Text("查看图文教程>>")
                                    .font(.system(size: 13.5))
                                    .foregroundColor(Color(hex: "#999999"))
                            }
                        }
                    }
                */
            }
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
