//
//  TSGifPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/12.
//

import SwiftUI
import CJViewElement_Swift
import WidgetKit
import CJImageKit_Swift

struct TSGifPage: View {
    var body: some View {
        NavigationView {
            VStack {
                CJAnimateImageViewRepresentable(
                    gifName: "Ayaka",
                    contentMode: .scaleAspectFill,
                    isAnimating: .constant(true)
                )
                .frame(width: 150, height: 150)
                .background(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            }
        }
        .onAppear() {
            print("TSGifPage onAppear")
        }
        .task {
            
        }
    }

}
