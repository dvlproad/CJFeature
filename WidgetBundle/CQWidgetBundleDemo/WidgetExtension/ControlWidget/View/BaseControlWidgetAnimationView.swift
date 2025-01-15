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
        // PNG
//        let imageView = Image("01_png")
        
        // SVG
//        let imageView = Image("emoji9_FFA5BE")
//        let imageView = Image("emoji9_FFA5BE_byPath", bundle: nil)
        //let uiimage = SVGImageUtil.loadImageSvgName("activity_byPath")      // 不是 SF Symbol，可以加载，但需要的是 SF Symbol
//        let uiimage = UIImage.loadImageSvgName("emoji9_FFA5BE_byPath") // SF Symbol 的 SVG 加载显示和打开看到的一样
//        let imageView = Image(uiImage: uiimage ?? UIImage())
        
        // SVG Render
//        let uiimage = UIImage.renderSFSymbolToImage(symbolName: "emoji9_FFA5BE_byPath", size: CGSize(width: 44, height: 44))
//        let imageView = Image(uiImage: uiimage ?? UIImage())
        
        // PDF
//        let imageView = Image("icons8-superman-pdf")
//        let imageView = Image(uiImage: uiimage ?? UIImage())
//        let uiimage = UIImage.loadPDFThumbnail(named: "icons8-ninja-turtle_byPath", size: CGSize(width: 44, height: 44
        
        // 共享目录下
        let sfsymbolPath = CJTestUtil.sfsymbolPath_inShareDir
        let uiimage_error = UIImage(contentsOfFile: sfsymbolPath)
        
        let size = CGSize(width: 44, height: 44)
        let uiimage = UIImage.getSFSymbol(symbolPath: sfsymbolPath, size: size)
        let imageView = Image(uiImage: uiimage ?? UIImage())
        
        // =======Success Example:=======
        
        
        // =======Success:=======
//        let imageView = Image(entity.imageName)
        
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
