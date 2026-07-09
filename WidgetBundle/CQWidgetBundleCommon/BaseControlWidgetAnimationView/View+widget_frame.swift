//
//  View+widget_frame.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//


import SwiftUI

public extension View {
    // 设置图片的大小
    func imageFrame(_ size: CGSize) -> some View {
        if isInWidget {
            return AnyView(
                self
            )
        } else {
            return AnyView(
                self
                    .frame(width: size.width, height: size.height)
            )
        }
    }
    
    // 设置视图的大小
    func widget_frame_bgColor_cornerRadius(size: CGSize, bgColor: Color, cornerRadius: CGFloat, borderColor: Color?, borderWidth: CGFloat?) -> some View {
        if isInWidget {
            return AnyView(
                self
                    .background(Color.white)
            )
        } else {
            return AnyView(
                self
                    .frame(width: size.width, height: size.height)
                    .background(bgColor)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor ?? Color.clear, lineWidth: borderWidth ?? 0)
                    )
                )
        }
    }
}

