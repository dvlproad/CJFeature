//
//  BaseControlWidgetView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI

struct BaseControlWidgetView: View {
    var entity: BaseControlWidgetEntity
    
    init(entity: BaseControlWidgetEntity) {
        self.entity = entity
    }
    
    var body: some View {
        Text(entity.title ?? "未知名")
    }
}
