//
//  BaseControlWidgetAnimationView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI
import CJWidgetKit_Swift
import CJAnimationKit_Swift
import SVGKit
import UIKit

struct BaseControlWidgetAnimationView: View {
    @Binding var entity: BaseControlWidgetEntity
    
    var body: some View {
        if isInWidget {
//            CJWidgetGifImageView(gifName: "transformer", defaultImage: "")
//                .frame(width: 40, height: 40)
        }
        BaseControlWidgetAnimationViewInApp(entity: $entity)
        
//        let imageView = Image(entity.imageName)
//        var imageScaleModel = entity.animateModel
//        imageView
//            .scaleEffect(imageScaleModel.isAnimating ? 0.2 : 1.0, anchor: .center)  // 设置缩放比例
//            .animation(
//                .easeInOut(duration: 3)
//                .repeatForever(autoreverses: true),
//                value: imageScaleModel.isAnimating
//            )
        
//            imageView
//                .rotateAnimation(.constant(true))
                
//                .rotationEffect(Angle.degrees(360))
//                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: true)
    }
}

struct BaseControlWidgetAnimationViewInApp: View {
    @Binding var entity: BaseControlWidgetEntity
    //@Binding var widgetStyle: ControlWidgetType
    
    var body: some View {
        // 系统SF图标
        // Image(systemName: "figure.walk")
        // 自定义SF图标
        //let imageView = Image("scissors.circle")  // "scissors.circle" 图片真机iOS18异常无显示
        //let imageView = Image("icons8-忍者神龟2")
//        let imageView = Image("icons8-ninja-turtle")

        // =======Failure Example:=======
    
        // =======Success Example:=======
        
        // =======Success:=======
        let imageView = Image(entity.imageModel.imageName)
        
        if #available(iOS 18.0, *) {
            imageView
                .resizable()
//                .symbolEffect(.bounce.up.byLayer, options: .repeat(.continuous))
//                .symbolEffect(.breathe.pulse.byLayer, options: .repeat(.continuous))
                .applyEffect(entity.symbolEffectType)
                .imageFrame(entity.widgetStyle)
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        } else {
            // Fallback on earlier versions
        }
        
        
//        var imageScaleModel = entity.animateModel
//        let type = imageScaleModel.type
//        if type == .woodenFish {
//            imageView
//                .woodenFishAnimation(Binding(get: { imageScaleModel }, set: { imageScaleModel = $0 as! WidgetImageScaleModel }))
////                    .scaleEffect(imageScaleModel.isScaledDown ? 0.8 : 1.0, anchor: .center)  // 设置缩放比例
////                    .animation(.easeInOut(duration: imageScaleModel.duration), value: imageScaleModel.isScaledDown)  // 动画时长
//        } else {
//            let bindingValue = Binding(get: { imageScaleModel.isAnimating }, set: { imageScaleModel.isAnimating = $0 })
////            imageView.cjAnimation(type: type, isAnimating: imageScaleModel.isAnimating)
//            imageView.cjAnimation(type: $entity.animateModel.type)
//        }
    }
}


// MARK: 预览 BaseControlWidgetAnimationViewInApp
struct BaseControlWidgetAnimationViewInApp_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .center, spacing: 0) {
            let entity = BaseControlWidgetEntity(
                id: UUID().uuidString,
                title: "控制组件",
                subTitle: "我是副标题",
                imageModel: CJBaseImageModel(id: "", name: "", imageName: "icon_control_katong_4"),
                imageAnimateType: .none,
                name: "",
                widgetStyle: .circle,
                bgColorString: "#ff0000"
            )
            
            BaseControlWidgetAnimationViewInApp(
                entity: .constant(entity)
            )
            .tint(Color.red)
            
            Button("Click me") {
                print("Button clicked")
            }
            .tint(.red) // 设置按钮的颜色为蓝色
            
            Image("field_close_gray")
                .renderingMode(.template) // 设置为模板模式
                .foregroundColor(.yellow) // 设置图标的颜色为黄色
            
            Image(systemName: "star.fill")
                .renderingMode(.template) // 设置为模板模式
                .tint(.red) // 设置图标的颜色为黄色
            
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            
            Image(systemName: "star.fill")
                .foregroundColor(.red) // 设置图标的颜色为黄色
            
            diffSymbols_typesView()
        }
        
    }
    
    // 不同 symbol 图标的各种不同渲染方法
    static func diffSymbols_typesView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            typesBatteryView(
                imageName: "battery.100percent.bolt",
                isSystemName: true
            )
            typesBatteryView(
                imageName: "icon_control_katong_4",
                isSystemName: false
            )
            typesBatteryView(
                imageName: "02_color_svg",
                isSystemName: false
            )
        }
    }
    
    static func typesBatteryView(imageName: String, isSystemName: Bool = false) -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text("单色模式 Monochrome")
            baseImageName(imageName, isSystemName)
                .foregroundStyle(.yellow)
            
            Text("分层模式 Hierarchical")
            baseImageName(imageName, isSystemName)
                .foregroundStyle(.yellow)
                .symbolRenderingMode(.hierarchical)
            
            Text("调色盘模式 Palette")
            baseImageName(imageName, isSystemName)
                .foregroundStyle(.red, .orange, .yellow)
                .symbolRenderingMode(.palette)
            
            Text("多色模式 Muticolor")
            baseImageName(imageName, isSystemName)
                .symbolRenderingMode(.multicolor)
        }
    }
    
    static func baseImageName(_ imageName: String, _ isSystemName: Bool = false) -> some View {
        if isSystemName {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 100, height: 100)
        } else {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}
