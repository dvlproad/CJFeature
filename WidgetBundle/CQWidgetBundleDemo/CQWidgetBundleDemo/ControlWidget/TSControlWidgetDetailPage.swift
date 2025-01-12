//
//  TSControlWidgetDetailPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift
import WidgetKit
import CJImageKit_Swift
import CJAnimationKit_Swift

//struct BounceModifier: ViewModifier {
//    @Binding var bounce: Bool
//    
//    func body(content: Content) -> some View {
//        content
//            .offset(y: bounce ? -20 : 0)
//            .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: bounce)
//    }
//}

struct TSControlWidgetDetailPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    var fromPageType: CQPageType
    @State var entity: BaseControlWidgetEntity
    
    @State private var showAnimationSheet: Bool = false
    
    var hasAdd: Bool {
        var hasAdd: Bool = false
        if let saveId = entity.saveId, saveId.count > 0 {
            hasAdd = true
        }
        return hasAdd
    }
    
    var gifImage: some View {
        CJAnimateImageViewRepresentable(
            gifName: "Ayaka",
            contentMode: .scaleAspectFill,
            isAnimating: .constant(true))
        .frame(width: 150, height: 150)
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
    }
    
    @State var animationType: AnimationType = .none
    @State private var bounce = false   // 是否弹跳
    @State private var swing = false    // 是否摆动
    @State private var rotate = false   // 是否旋转
    @State private var breathe = false  // 是否呼吸
    @State private var pulse = false    // 是否脉冲
    var body: some View {
        VStack {
            
            Text("\(entity.id)当前数据为: \(entity.title)")
            //BaseControlWidgetView(entity: entity)
            BaseControlWidgetView(bindingEntity: $entity)
            Spacer(minLength: 20)
            
            VStack {
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
                
                
                HStack {
                    Image("icon_control_katong_5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .rotateAnimation($rotate)
    //                    .onTapGesture {
    //                        rotate.toggle()
    //                    }
    //                gifImage
    //                    .bounceAnimation($bounce)
                    Image("icon_control_katong_6")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
//                        .bounceAnimation($bounce)
                        .bounceAnimation(.constant(animationType == .bounce))
                        .rotateAnimation(.constant(animationType == .rotate))
                        .cjAnimation(type: $animationType)
                }
                .background(Color.gray)
            }
        }
        
        ZStack {
            Button(hasAdd ? "保存组件" : "添加组件") {
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
        .sheet(isPresented: $showAnimationSheet) {
            // 表单内容
            NavigationView {
                Form {
                    Section {
                        // 选项1
                        Button("无动画") {
                            // 选项1的处理逻辑
                            bounce = false
                            rotate = false
                            entity.animateModel.type = .none
                            updateUI()
                            showAnimationSheet = false
                        }
                        // 选项2
                        Button("弹跳") {
                            // 选项2的处理逻辑
                            bounce = true
                            rotate = false
                            entity.animateModel.type = .bounce
                            updateUI()
                            showAnimationSheet = false
                        }
                        // 选项3
                        Button("旋转") {
                            // 选项3的处理逻辑
                            bounce = false
                            rotate = true
                            entity.animateModel.type = .rotate
                            updateUI()
                            showAnimationSheet = false
                        }
                    }
                }
                .navigationBarTitle("选择动画")
            }
        }
        .onAppear() {
            print("TSControlWidgetDetailPage onAppear")
            bounce = true
            swing = true
            rotate = true
            breathe = true
            pulse = true
        }
        .task {
            
        }
        
        
    }
    
    private func updateUI() {
        animationType = entity.animateModel.type
    }
    
}
