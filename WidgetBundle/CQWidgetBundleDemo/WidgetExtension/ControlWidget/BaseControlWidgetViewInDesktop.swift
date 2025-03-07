//
//  BaseControlWidgetViewInDesktop.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI

struct BaseControlWidgetViewInDesktop: View {
    @Binding var entity: BaseControlWidgetEntity
    var pageInfo: CCPageInfo
    
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
    
    var body: some View {
            let onoffModel = entity.getStateModel()
            Label {
                Text("\(onoffModel.title)")
                Text("\(onoffModel.subTitle)")
            } icon: {
                // 系统SF图标
                // Image(systemName: "figure.walk")
                // 自定义SF图标
                // Image(entity.imageName)
                
                BaseControlWidgetAnimationView(
                    onoffModel: Binding<CJControlWidgetOnOffModel>(
                        get: { entity.getStateModel() },
                        set: {
                            if entity.isOn {
                                entity.onModel = $0
                            } else {
                                entity.offModel = $0
                            }
                        }
                    ),
                    symbolEffectType: $entity.symbolEffectType,     // 控制中心不需要自己根据状态切换动画，app内要自己切换
                    widgetStyle: $entity.widgetStyle
                )
            }
            // 桌面的 tint 必须在 ControlWidgetToggle 的 label 下设置，不能放在在此
    }
}
