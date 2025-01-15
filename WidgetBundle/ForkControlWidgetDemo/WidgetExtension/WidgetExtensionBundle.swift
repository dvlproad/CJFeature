//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by qian on 2025/1/15.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionControl()
        WidgetExtensionLiveActivity()
    }
}
