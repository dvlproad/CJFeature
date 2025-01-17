//
//  QuickStartInputView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import SwiftUI
import CJViewElement_Swift

struct QuickStartInputView: View {
    @Binding var appModel: QuickStartAppModel?
    @Binding var shortcutsModel: QuickStartShortcutsModel?
    @Binding var webModel: QuickStartWebModel?
    
    @State var currentSegmentModel: BaseSegmentModel?
    @State var shortcutsName: String = ""
    @State var webUrl: String = ""
    
    let options = [
        BaseSegmentModel(segmentId: "0", text: "无操作", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: "1", text: "快捷启动", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: "2", text: "快捷指令", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: "3", text: "自定义", textFontSize: 13, width: 66)
    ]
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 10) {
                CustomSegmentView(
                    options: options,
                    currentSelectedModel: $currentSegmentModel,
                    height: 32.0,
                    onChangeOfModel: { option in
                        currentSegmentModel = option
                    }
                )
                
                let textFieldHeight = 40.0
                VStack(alignment: .center, spacing: 0) {
                    let currentSegmentIndex = options.firstIndex(where: { $0.segmentId == currentSegmentModel?.segmentId }) ?? 0
                    if currentSegmentIndex == 1 {
                        let appName = appModel?.appName ?? "请选择"
                        TitleRowView(title: "选择快捷启动", value: appName, onTapValue: {
                            //showAnimationSheet.toggle()
                        })
                        .frame(height: 30)
                        .padding(.horizontal, 10)
                        
                    } else if currentSegmentIndex == 2 {
                        CJTextSettingRow(
                            title: "指令名称",
                            text: $shortcutsName,
                            placeHolder: "请输入文案",
                            lineLimit: 1,
                            textFieldHeight: textFieldHeight,
                            textDidChange: { value in
                                shortcutsName = value
                            }
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        
                        let encodeShortcutsName = shortcutsName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let shortcutsUrl = "name=\(encodeShortcutsName ?? "")" //shortcuts://run-shortcut?
                        CJTextSettingRow(
                            title: "网址",
                            text: .constant(shortcutsUrl),
                            placeHolder: "请输入你想要跳转的网址",
                            isEditable: false,
                            lineLimit: 1,
                            textFieldHeight: textFieldHeight,
                            textDidChange: { value in
                                
                            }
                        )
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        
                    } else if currentSegmentIndex == 3 {
                        CJTextSettingRow(
                            title: "网址",
                            text: $webUrl,
                            placeHolder: "请输入你想要跳转的网址",
                            lineLimit: 1,
                            textFieldHeight: textFieldHeight,
                            textDidChange: { value in
                                webUrl = value
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
            if let appModel = appModel {
                currentSegmentModel = options[1]
            } else if let shortcutsModel = shortcutsModel {
                currentSegmentModel = options[2]
            } else if let webModel = webModel {
                currentSegmentModel = options[3]
            } else {
                currentSegmentModel = options[0]
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
