//
//  RotateAnimateView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/12.
//
//  实现旋转的几种方法

import WidgetKit
import SwiftUI
import AppIntents

struct RotateAnimateView1: View {
    var body: some View {
        VStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: currentAngle))
            
            Button(intent: RotateAnimateIntent1()) {
                Text("旋转按钮")
            }
        }
    }
}

// 全局旋转角度
var currentAngle: Double = 0
var currentAngleEnabled = false

struct RotateAnimateIntent1: AppIntent {
    static var title: LocalizedStringResource = "旋转按钮"
    
    func perform() async throws -> some IntentResult {
        currentAngleEnabled = !currentAngleEnabled
        tick(0.25)
        return .result()
    }
}

private func tick(_ duration: TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        if (!currentAngleEnabled) {
            return
        }
        withAnimation(.easeInOut(duration: 5.0)) {
            currentAngle += 90 // 每次旋转90度
        }
        WidgetCenter.shared.reloadAllTimelines()
        tick(duration)
    }
}



