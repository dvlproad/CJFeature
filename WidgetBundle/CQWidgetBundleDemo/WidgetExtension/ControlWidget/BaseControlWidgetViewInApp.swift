//
//  BaseControlWidgetViewInApp.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CQWidgetBundleCommon // 需要引入 ControlWidgetStyle

struct BaseControlWidgetViewInApp: View {
    @Binding var entity: BaseControlWidgetEntity
    var pageInfo: CCPageInfo
//    @Binding var widgetStyle: ControlWidgetStyle  // 在app内的形态（控制中心不提供获取）
    
    // 接收值类型并包装成临时的 Binding
    init(entity: BaseControlWidgetEntity, pageInfo: CCPageInfo) {
        self._entity = .constant(entity)
        self.pageInfo = pageInfo
    }
    
    // 接收 @State
    init(stateEntity: State<BaseControlWidgetEntity>, pageInfo: CCPageInfo) {
        self._entity = stateEntity.projectedValue // 使用 projectedValue 获取 Binding
        self.pageInfo = pageInfo
    }
    
    // 接收 @Binding
    init(bindingEntity: Binding<BaseControlWidgetEntity>, pageInfo: CCPageInfo) {
        self._entity = bindingEntity
        self.pageInfo = pageInfo
    }
    
    func scale(currentSize: CGSize) -> CGFloat {
        return currentSize.width/entity.widgetStyle.designSizeInApp.width
//        if pageInfo.pageType == .myWidgetPage {
//            if entity.widgetStyle == .rectangle {
//                return currentSize.width/entity.widgetStyle.designSizeInApp.width
//            } else if entity.widgetStyle == .square {
//                return currentSize.width/entity.widgetStyle.designSizeInApp.width
//            }
//        }
//        return 1.0
    }
    
    /*
    func containerViewSize(geometry: GeometryProxy, widgetStyle: ControlWidgetStyle) -> CGSize {
        if pageInfo.pageType == .homePage {
            return geometry.size
        }
        return widgetStyle.designSizeInApp
    }
    */
    func containerViewCornerRadius(containerViewSize: CGSize, widgetStyle: ControlWidgetStyle) -> CGFloat {
        if widgetStyle == .circle {
            if pageInfo.pageType != .inDesktop {
                let diameter = min(containerViewSize.width, containerViewSize.height)
                return diameter/2
            }
        }
        return widgetStyle.designCornerRadius
    }
    
    /*
    private func getBgColorInApp() -> Color {
        if pageInfo.pageType == .controlWidgetPerviewPage {
            return Color(hex:"#4C000000")
        }
        
        if entity.bgColorString == nil { // 后台没有设置颜色适合，前端各页面显示的颜色
            if pageInfo.pageType == .controlWidgetDetailPage {
                return Color(hex:"#FFFFFF")
            } else if pageInfo.pageType == .myWidgetPage {
                return Color(hex:"#C7C7C7")
            }
            return Color(hex:"#C7C7C7")
        }
        return Color(hex:entity.bgColorString!)
    }
    
    private func getTintColorInApp() -> Color? {
        let unableTintColor = pageInfo.pageType == .controlWidgetDetailPage && entity.isOffInDetailPage == true
        return unableTintColor ? nil : entity.tintColor
    }
    */
    
    // 【【IOS18控制中心】控制中心，几个地方的图标显示需要优化】https://www.tapd.cn/tapd_fe/66656887/bug/detail/1166656887001001589
    private func getColorTupleInApp() -> (bgColor: Color, tintColor: Color?, borderWidth: CGFloat?, borderColor: Color?, titleColor: Color, subTitleColor: Color) {
        var bgColor: Color
        var tintColor: Color?
        var borderWidth: CGFloat?
        var borderColor: Color?
        var titleColor: Color = Color(hex: "#333333")
        var subTitleColor: Color = Color(hex: "#999999")
        
        let quickStartTintColor: Color = Color.white.opacity(0.8)
        
        let bgColorIfExsit = entity.bgColorString != nil ? Color(hex:entity.bgColorString!) : nil // 后台设置的背景颜色
        // 后台没有设置颜色时候，前端各页面使用自己默认的颜色
        if pageInfo.pageType == .controlWidgetPerviewPage {
            if entity.quickStartEnable == true {
                // 预览界面的样式调整:快捷启动的预览样式，统一灰色
                bgColor = Color(hex:"#4C000000")    // 预览页固定背景色 76/255.0≈0.298 的黑色
                tintColor = quickStartTintColor
                titleColor = quickStartTintColor
                subTitleColor = quickStartTintColor
            } else {
                // 预览界面的样式调整:图标的组件预览样式，显示开启的样式。白色底+带颜色的图标
                bgColor = Color.white
                tintColor = entity.tintColor
            }
            
        } else if pageInfo.pageType == .controlWidgetDetailPage {
            if entity.quickStartEnable == true {
                // 控制中心选择图标:快捷启动的组件，统一灰色显示，图标显示白色
                bgColor = bgColorIfExsit ?? Color(hex:"#C7C7C7")
                tintColor = quickStartTintColor
                titleColor = quickStartTintColor
                subTitleColor = quickStartTintColor
            } else {
                // 控制中心选择图标: 图标组件，统一白色底显示，图标显示对应的色值
                bgColor = bgColorIfExsit ?? Color(hex:"#FFFFFF")
                tintColor = entity.isOffInDetailPage == true ? nil : entity.tintColor   // 关闭状态不需要颜色
            }
            
            
        } else if pageInfo.pageType == .myWidgetPage {
            if entity.quickStartEnable == true {
                // 我的组件样式调整:快捷启动的组件，统一灰色显示
                bgColor = bgColorIfExsit ?? Color(hex:"#C7C7C7")
                tintColor = quickStartTintColor
                titleColor = quickStartTintColor
                subTitleColor = quickStartTintColor
            } else {
                // 我的组件样式调整:图标组件，统一白色底显示
                bgColor = Color.white
                tintColor = entity.tintColor
                borderWidth = 1.0
                borderColor = Color(hex:"#F5F5F5")
            }
            
        } else {
            bgColor = bgColorIfExsit ?? Color(hex:"#C7C7C7")
            tintColor = entity.tintColor
        }
        
        return (bgColor, tintColor, borderWidth, borderColor, titleColor, subTitleColor)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let widgetStyle = entity.widgetStyle
            
            let currentSize = geometry.size
            let scale = scale(currentSize: currentSize)
            let cornerRadius = containerViewCornerRadius(containerViewSize: currentSize, widgetStyle: widgetStyle)
            
            let colorTupleInApp = getColorTupleInApp()
            containerView(scale: scale, titleColor: colorTupleInApp.titleColor, subTitleColor: colorTupleInApp.subTitleColor)
                .widget_frame_bgColor_cornerRadius(
                    size: currentSize,
                    bgColor: colorTupleInApp.bgColor,
                    cornerRadius: cornerRadius,
                    borderColor: colorTupleInApp.borderColor,
                    borderWidth: colorTupleInApp.borderWidth
                )
                .controlWidget_tintColor(colorTupleInApp.tintColor, isInWidget: false)
        }
    }
    
    func containerView(scale: CGFloat, titleColor: Color, subTitleColor: Color) -> some View {
        let imageSize = entity.widgetStyle.imageSizeInApp
        
//        let onoffModel = isOn ? entity.onModel : entity.offModel
        var isOff = false
        if pageInfo.pageType == .controlWidgetDetailPage {
            isOff = entity.isOffInDetailPage == true
        } else if pageInfo.pageType == .inDesktop {
            isOff = !entity.isOn
        }
        var onoffModel = (isOff && entity.offModel != nil)  ? entity.offModel! : entity.onModel
        
//        let imageView = BaseControlWidgetAnimationView(entity: $entity, isOn: $isOn)
        let imageView = BaseControlWidgetAnimationView(
            onoffModel: Binding<CJControlWidgetOnOffModel>(
                get: { onoffModel }, set: { onoffModel = $0 }
            ),
//            symbolEffectType: Binding<SymbolEffectType>(
//                get: { entity.symbolEffectType }, set: { entity.symbolEffectType = $0 }
//            ),
            symbolEffectType: isOff ? .constant(.none) : $entity.symbolEffectType,
            widgetStyle: Binding<ControlWidgetStyle>(
                get: { entity.widgetStyle }, set: { entity.widgetStyle = $0 }
            )
        )
            .frame(width: imageSize.width * scale, height:  imageSize.width * scale)
        
        let titleView = Text(onoffModel.title)
            .lineLimit(2)
            .foregroundColor(titleColor)
            .font(.system(size: (entity.widgetStyle == .square ? 13 : 12) * scale, weight: .regular))
            //.font(.system(size: pageInfo.pageType == .myWidgetPage ? 12 : 16, weight: .regular))
            .minimumScaleFactor(0.5)
        let subTitleView = Text(onoffModel.subTitle)
            .lineLimit(1)
            .foregroundColor(subTitleColor)
            .font(.system(size: (entity.widgetStyle == .square ? 13 : 12) * scale, weight: .regular))
            //.font(.system(size: pageInfo.pageType == .myWidgetPage ? 10 : 12, weight: .regular))
            .minimumScaleFactor(0.5)
        
        
        let widgetStyle = entity.widgetStyle
        switch widgetStyle {
        case .circle:
            return AnyView(imageView)
            
        case .rectangle:
            return AnyView(
                HStack(alignment: .center, spacing: 0) {
                    imageView
                    Spacer().frame(width: 8 * scale)
                    VStack(alignment: .leading, spacing: 0) {
                        if onoffModel.title.count > 0 {
                            titleView
                        }
                        if onoffModel.subTitle.count > 0 {
                            subTitleView
                        }
                    }
                    Spacer()
                }
                    .padding(.leading, 16 * scale)
                    .padding(.trailing, 16 * scale)
                    .padding(.top, 10 * scale)
                    .padding(.bottom, 10 * scale)
            )
        case .square:
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        imageView
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            if onoffModel.title.count > 0 {
                                titleView
                            }
                            if onoffModel.subTitle.count > 0 {
                                subTitleView
                            }
                        }
                        Spacer()
                    }
                }
                    .padding(.leading, 16 * scale)
                    .padding(.trailing, 12 * scale)
                    .padding(.top, 10 * scale)
                    .padding(.bottom, 20 * scale)
            )
            
        }
    }
}


public class CCBorderModel {
    var color: String?          // 边框颜色
    var width: CGFloat?         // 边框图片
}
