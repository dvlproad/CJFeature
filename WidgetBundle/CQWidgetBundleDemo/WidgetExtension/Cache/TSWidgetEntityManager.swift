//
//  TSControlWidgetEntityManager.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation
import CQWidgetBundleCommon

class TSWidgetEntityManager {
    static let shared = TSWidgetEntityManager()
    
    var controlWidgetEntitys: [BaseControlWidgetEntity] = []
    init() {
        controlWidgetEntitys = TSWidgetBundleCacheUtil.getCacheControlWidgets(.all)
    }
}
