//
//  RotateAnimateViewAndIntent4.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/12.
//

import SwiftUI
import ClockHandRotationKit

struct RotateAnimateView4: View {
    var body: some View {
        // 文字翻转
        Text("ClockRotationEffect")
            .modifier(ClockHandRotationModifier(period: .secondHand, timeZone: TimeZone.current, anchor: .center))
    }
}
