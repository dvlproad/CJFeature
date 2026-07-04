//
//  ControlWidgetTitleView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift

struct ControlWidgetTitleRowView: View {
    var title: String
    var subTitle: String?
    
    @Binding var showRecover: Bool
    var onTapRecover: (() -> Void)?
    
    @Binding var value: String?
    var onTapValue: (() -> Void)?
    
    init(title: String,
         subTitle: String? = nil,
         showRecover: Binding<Bool> = .constant(false),
         onTapRecover: (() -> Void)? = nil,
         value: String?,
         onTapValue: (() -> Void)? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        
        self._showRecover = showRecover
        self.onTapRecover = onTapRecover
        
        self._value = .constant(value)
        self.onTapValue = onTapValue
    }
    
    init(title: String,
         subTitle: String? = nil,
         showRecover: Binding<Bool> = .constant(false),
         onTapRecover: (() -> Void)? = nil,
         bindingValue: Binding<String?> = .constant(nil),
         onTapValue: (() -> Void)? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        
        self._showRecover = showRecover
        self.onTapRecover = onTapRecover
        
        self._value = bindingValue
        self.onTapValue = onTapValue
    }
    
    var body: some View {
        CJSettingTitleRow(
            title: title,
            subTitle: subTitle,
            showRecoverIcon: $showRecover,
            onTapRecover: onTapRecover
        )
        .withTailingValue($value, onTapValue: onTapValue)
    }
}
