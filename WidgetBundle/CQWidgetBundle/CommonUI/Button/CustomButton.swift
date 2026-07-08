//
//  TempShouldRemove.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2024/1/10.
//

import SwiftUI

public struct CustomButton<LabelView:View>: View {
    let labelView: LabelView
    var tapComplete: () -> Void = { }
    let bgColor:Color
    let radius:CGFloat
    // 使用 @ViewBuilder 来允许传入自定义的视图
    public init(
        tapComplete:@escaping () -> Void = { },
        @ViewBuilder labelView: () -> LabelView,
        bgColor:Color,
        radius:CGFloat
    ) {
        self.tapComplete = tapComplete
        self.labelView = labelView()
        self.bgColor = bgColor
        self.radius = radius
    }
    
    public var body: some View {
        GeometryReader(content: { geometry in
            Button(action: {
                tapComplete()
            }, label: {
                ZStack {
                    Rectangle() // 可以是透明的，用于确保点击事件被捕捉
                        .foregroundColor(.clear)
                        .contentShape(Rectangle()) // 确保整个区域都是可点击的
                    labelView
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 使用最大尺寸填充按钮
                }
            })
            .frame(width: geometry.size.width,height: geometry.size.height)
            .background(bgColor)
            .cornerRadius(radius)
            .buttonStyle(StaticButtonStyle())
        })
    }
}

public struct StaticButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
