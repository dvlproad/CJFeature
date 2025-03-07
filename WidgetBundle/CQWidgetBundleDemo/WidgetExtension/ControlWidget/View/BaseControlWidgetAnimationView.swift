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

/// 在小组件中
let isInWidget = Bundle.main.bundlePath.hasSuffix(".appex")

struct BaseControlWidgetAnimationView: View {
    @Binding var onoffModel: CJControlWidgetOnOffModel
    @Binding var symbolEffectType: SymbolEffectType
    @Binding var widgetStyle: ControlWidgetStyle  // 在app内的形态（控制中心不提供获取）
    
//    @Binding var entity: BaseControlWidgetEntity
//    @Binding var isOn: Bool
    
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
        let imageView = onoffModel.imageModel.createImageView()
        
        if #available(iOS 18.0, *) {
            GeometryReader { geometry in
//                let size = widgetStyle.imageSizeInApp
                let size = geometry.size
                imageView
                    .resizable()
//                    .symbolEffect(.bounce.up.byLayer, options: .repeat(.continuous))
//                    .symbolEffect(.breathe.pulse.byLayer, options: .repeat(.continuous))
                    .applyEffect(symbolEffectType)
                    .aspectRatio(contentMode: .fit) // kn: aspectRatio 要在 frame设置前，否则会导致变形(如详情的顶部headerView或者预览页面)
                    .imageFrame(size)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
