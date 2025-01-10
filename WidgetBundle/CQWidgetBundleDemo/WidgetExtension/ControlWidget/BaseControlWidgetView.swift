//
//  BaseControlWidgetView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI


struct BaseControlWidgetView: View {
    var entity: BaseControlWidgetEntity
    
    init(entity: BaseControlWidgetEntity) {
        self.entity = entity
    }
    
    var body: some View {
        Label {
            Text("\(entity.id): \(entity.title)")
            Text(entity.subTitle)
        } icon: {
            // 系统SF图标
            // Image(systemName: "figure.walk")
            // 自定义SF图标
            Image(entity.imageName)
        }
    }
}
