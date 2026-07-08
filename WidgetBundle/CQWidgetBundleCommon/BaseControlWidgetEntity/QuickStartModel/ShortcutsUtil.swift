//
//  QuickStartAppModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//

import Foundation


struct ShortcutsUtil {
    static func shortcutsUrl(shortcutsName: String) -> String {
//        let shortcutsName = "添加新提醒事项"
//        let shortcutsText = "Open List"
        let appUrl = "shortcuts://run-shortcut?name=\(shortcutsName)&input=text&text=\(shortcutsName)"
        return appUrl
    }
}
