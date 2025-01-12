//
//  BaseControlWidgetView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJAnimationKit_Swift

struct BaseControlWidgetView: View {
    @Binding var entity: BaseControlWidgetEntity
    // 接收值类型并包装成临时的 Binding
    init(entity: BaseControlWidgetEntity) {
        self._entity = .constant(entity)
    }
    
    // 接收 @State
    init(stateEntity: State<BaseControlWidgetEntity>) {
        self._entity = stateEntity.projectedValue // 使用 projectedValue 获取 Binding
    }
    
    // 接收 @Binding
    init(bindingEntity: Binding<BaseControlWidgetEntity>) {
        self._entity = bindingEntity
    }
    
    @State private var isOn: Bool = false
    @State private var rotationAngle: Double = 0
    
    @State private var rotate = false   // 是否旋转
    var body2: some View {
//        let imageView = Image(entity.imageName)
////        imageView.rotateAnimation(.constant(true))
////        
////        Image(systemName: "arrow.2.circlepath")
//        imageView
////            .resizable()
////            .frame(width: 100, height: 100)
//            .rotateAnimation($rotate)      //  可以 ✅
//        //SwiftUI 的动画系统需要某种形式的状态变更（比如 @State 或 @Binding）来触发动画。如果没有 @State，动画可能无法触发，或者仅仅执行一次，不会循环。
////            .rotateAnimation(.constant(true)) // 失败 ❌
////            .rotateAnimation2(true) // 失败 ❌
//            .onTapGesture {
//                rotate.toggle()
//            }
//            .onAppear() {
//                rotate = true
//            }
        
        Image(systemName: "arrow.2.circlepath")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(rotationAngle)) // 添加旋转效果
//            .animation(
//                Animation.linear(duration: 2.0)
//                    .repeatForever(autoreverses: false),
//                value: rotationAngle
//            )
            .scaleEffect(entity.isOn ? 0.8 : 1.0, anchor: .center)  // 设置缩放比例
            .animation(.easeInOut(duration: 0.2), value: entity.isOn)  // 动画时长
            .onAppear {
                rotationAngle = 360 // 开始旋转
            }
    }
    
    var body: some View {
        Label {
            Text("\(entity.title)")
            Text("\(entity.subTitle)(\(entity.id))")
        } icon: {
            // 系统SF图标
            // Image(systemName: "figure.walk")
            // 自定义SF图标
            // Image(entity.imageName)
            
            BaseControlWidgetAnimationView(entity: $entity)
            
        }
    }
}
