//
//  QuickStartWebModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation

public struct QuickStartWebModel: ControlWidgetBaseModel, Hashable {
    public var name: String

    public var targetUrl: String
    
    public init(name: String, targetUrl: String) {
        self.name = name
        self.targetUrl = targetUrl
    }
}
