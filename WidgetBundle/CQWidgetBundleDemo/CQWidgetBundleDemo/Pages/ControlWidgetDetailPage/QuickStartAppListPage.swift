//
//  QuickStartAppListPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/18.
//

import SwiftUI

struct QuickStartAppListPage: View {
    @Binding var isActive: Bool
    @State var appModel: QuickStartAppModel?
    var onChangeOfApp: ((QuickStartAppModel) -> Void)
    
    init(isActive: Binding<Bool>,
         appModel: QuickStartAppModel? = nil,
         onChangeOfApp: @escaping (QuickStartAppModel) -> Void
    ) {
        self._isActive = isActive
        self.appModel = appModel
        self.onChangeOfApp = onChangeOfApp
    }
    
    var body: some View {
        NavigationLink(isActive: $isActive) {
            QuickStartAppListView(
                selectedApp: { newAppModel in
                    onChangeOfApp(newAppModel)
                }
            )
        } label: {
        }
    }
}
