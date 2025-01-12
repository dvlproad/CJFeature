//
//  RotateAnimateViewAndIntent3.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/12.
//

import SwiftUI
import ClockHandRotationKit

struct RotateAnimateView3: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 340, height: 1)
                .foregroundColor(.red.opacity(1))
            ZStack {
                RectangleView1()
                RectangleView2().offset(x: 75)
            }
            .modifier(ClockHandRotationModifier(period: .custom(-10), timeZone: TimeZone.current, anchor: .center))
        }
    }
}



struct RectangleView1: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 150, height: 30)
                .foregroundColor(.red.opacity(0.1)) // 作者的代码透明度为0

            Color.white
                .frame(width: 1, height: 1)
                .foregroundColor(.white)
        }
    }
}

struct RectangleView2: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 75*2, height: 30)
                .foregroundColor(.blue.opacity(0.1)) // 作者的代码透明度为0

            Rectangle()
                .frame(width: 90, height: 30)
                .foregroundColor(.black.opacity(0.1)) // 作者的代码透明度为0
                .offset(x: 75 / 2 + 7.5)

            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundColor(.black.opacity(1))
                .modifier(ClockHandRotationModifier(period: ClockHandRotationPeriod.custom(-10), timeZone: TimeZone.current, anchor: .center))
                .offset(x: 75)

            Color.white
                .frame(width: 1, height: 1)
                .foregroundColor(.white)
        }
        .modifier(ClockHandRotationModifier(period: .custom(5), timeZone: TimeZone.current, anchor: .center))
    }
}
