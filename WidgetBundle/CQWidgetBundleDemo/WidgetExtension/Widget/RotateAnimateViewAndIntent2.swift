//
//  RotateAnimateIntent.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/12.
//

import WidgetKit
import SwiftUI
import AppIntents

struct RotateAnimateView2: View {
    var body: some View {
        VStack {
            // 旋转动画
            if (isRotating) {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clockHandRotationEffect(period: .custom(1), in: TimeZone.current, anchor: .top)
            } else {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            
            Button(intent: RotateAnimateIntent2()) {
                Text("旋转按钮")
            }
        }
    }
}


// 全局旋转状态
var isRotating = false
struct RotateAnimateIntent2: AppIntent {
    static var title: LocalizedStringResource = "旋转按钮"
    
    func perform() async throws -> some IntentResult {
        isRotating = !isRotating
        return .result()
    }
}
