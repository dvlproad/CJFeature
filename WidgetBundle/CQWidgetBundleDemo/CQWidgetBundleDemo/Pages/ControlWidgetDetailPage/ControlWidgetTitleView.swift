//
//  ControlWidgetTitleView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI

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
        ControlWidgetTitleActionView(
            title: title,
            subTitle: subTitle,
            showRecover: $showRecover,
            onTapRecover: onTapRecover
        )
        .withTailingValue($value, onTapValue: onTapValue)
        /*
        HStack(alignment: .center, spacing: 0) {
            ControlWidgetTitleActionView(
                title: title,
                subTitle: subTitle,
                showRecover: $showRecover,
                onTapRecover: onTapRecover
            )
            
            Spacer()
            if let valueString = value {
                HStack(alignment: .center, spacing: 0) {
                    Text(valueString)
                        .font(.system(size: 13.5, weight: .regular))
                        .foregroundColor(Color(hex: "#999999"))
                    Image("arrow_right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 6, height: 10, alignment: .center)
                        .padding(.leading, 10)
                }
                .onTapGesture {
                    onTapValue?()
                }
            }
        }
        */
    }
}



struct ControlWidgetTitleActionView: View {
    var title: String
    var subTitle: String?
    
    @Binding var showRecover: Bool
    var onTapRecover: (() -> Void)?
    
    init(title: String,
         subTitle: String? = nil,
         showRecover: Binding<Bool> = .constant(false),
         onTapRecover: (() -> Void)? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        
        self._showRecover = showRecover
        self.onTapRecover = onTapRecover
    }
    
    var body: some View{
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .foregroundColor(Color(hex: "#333333"))
                .font(.system(size: 15.5, weight: .medium))
            if let subTitle = subTitle, subTitle.count > 0 {
                Text(subTitle)
                    .foregroundColor(Color(hex: "#999999"))
                    .font(.system(size: 13.5, weight: .regular))
            }
            
            Button(action: {
                onTapRecover?()
            }, label: {
                ZStack {
                    Rectangle() // 可以是透明的，用于确保点击事件被捕捉
                        .foregroundColor(.clear)
                        .contentShape(Rectangle()) // 确保整个区域都是可点击的
                    
                    if showRecover {
                        Image("recover")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 12, height: 12)
                    }
                }
            })
            .buttonStyle(StaticButtonStyle())
            .frame(width: 12.0)
            .padding(.leading, 7.5)
            //.background(Color.red)
            
            Spacer()
        }
    }
}

#Preview {
    return ControlWidgetTitleActionView(title: "背景颜色", subTitle: "（最小尺寸中不显示）", showRecover: .constant(true)) {
        
    }
}
