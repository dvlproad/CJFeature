//
//  QuickStartAppExample.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/18.
//

import Foundation
import CQWidgetBundleCommon

struct QuickStartAppExample {
    static let hotApps: [QuickStartAppModel] = [
        QuickStartAppModel.calshowAppModel(),
        QuickStartAppModel.shortcutsAppModel(),
        QuickStartAppModel.mobilenotesAppModel()
    ]
}
