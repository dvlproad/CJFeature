//
//  ControlWidgetAudioRow.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/20.
//

import SwiftUI
import CQWidgetBundle   // 需要使用 CustomButton

struct ControlWidgetAudioRow: View {
    @Binding var haveAudio:Bool
    var body: some View{
        HStack(spacing: 0){
            Text("桌面音频")
                .font(.system(size: 15.5,weight: .medium))
                .foregroundColor(Color(hex: "#333333"))
            CustomButton(tapComplete: {
//                let alert = SWAlertController(title: "桌面音频",
//                                              message: "打开桌面音频，在桌面点击小组件会播放音频",
//                                              confirmTitle: "我知道了",
//                                              confirmHandler: {action in
//                },
//                                              cancelTitle: nil,
//                                              cancelHandler: { action in
//                })
//                alert.show()
            }, labelView: {
                HStack{
                    Image("accessory_tip")
                        .resizable()
                        .frame(width: 15,height: 15)
                }
            }, bgColor: Color.clear, radius: 0)
            .frame(width: 21,height: 45)
         
            Spacer()
            Toggle(isOn: $haveAudio) {
                
            }
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#2E2E2E")))
        }.frame(height: 45)
            .padding(.horizontal,21)
    }
}
