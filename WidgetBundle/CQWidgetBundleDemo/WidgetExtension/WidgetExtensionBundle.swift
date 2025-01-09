//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by qian on 2025/1/9.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionControl()
        WidgetExtensionLiveActivity()
        
        if #available(iOS 18.0, *) {
            // Demo
            ControlToggleWidget()
        }
    }
}
