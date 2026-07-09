//
//  QuickStartUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/24.
//

import UIKit

public class QuickStartUtil: NSObject {
    /// 尝试打开快捷指令中心
    public static func openShortcutsApp() {
        if let url = URL(string: "shortcuts://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                TSToastUtil.showMessage("未找到快捷指令应用")
            }
        }
    }
}
