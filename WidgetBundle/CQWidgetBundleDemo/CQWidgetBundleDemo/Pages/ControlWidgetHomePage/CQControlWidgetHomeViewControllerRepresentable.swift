//
//  CQControlWidgetHomeViewWrapper.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import SwiftUI

// 使用 UIViewControllerRepresentable 包装 CQControlWidgetHomeViewController
struct CQControlWidgetHomeViewControllerRepresentable: UIViewControllerRepresentable {
    var onTapEntity: ((BaseControlWidgetEntity) -> Void)
    
    func makeUIViewController(context: Context) -> CQControlWidgetHomeViewController {
        return CQControlWidgetHomeViewController(onTapEntity: onTapEntity)
    }

    func updateUIViewController(_ uiViewController: CQControlWidgetHomeViewController, context: Context) {
        // 如果需要，可以在这里更新 UIViewController 的状态
    }
}
