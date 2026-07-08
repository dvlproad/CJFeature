//
//  View+ControlWidget.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func controlWidget_tintColor(_ color: Color?, isInWidget: Bool) -> some View {
        if isInWidget {
            if #available(iOS 16.0, *) {
                self.tint(color)
            } else {
                self
            }
        } else {
            self.foregroundStyleWithColor(color)
        }
    }
    
    @ViewBuilder
    private func foregroundStyleWithColor(_ color: Color?) -> some View {
        if let color = color {
            if #available(iOS 15.0, *) {
                self.foregroundStyle(color)
            } else {
                self
            }
        } else {
            self
        }
    }
}
