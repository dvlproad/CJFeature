//
//  StyleSegmentedView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI


public enum ControlWidgetType: String, Sendable, CaseIterable, Codable {
    case circle     // 圆形
    case rectangle  // 长方形
    case square     // 正方形
    
    // 在 app 内时候，该组件中的图片的大小
    var imageSizeInApp: CGSize {
        switch self {
        case .circle:
            return CGSize(width: 30, height: 30)
        case .rectangle:
            return CGSize(width: 40, height: 40)
        case .square:
            return CGSize(width: 45, height: 45)
        }
    }
    
    // 在 app 内时候，该组件中的图片的大小
    
    var designSizeInApp: CGSize {
        let length1: CGFloat = 60.0
        let length2: CGFloat = 150.0
        switch self {
        case .circle:
            return CGSize(width: length1, height: length1)
        case .rectangle:
            return CGSize(width: length2, height: length1)
        case .square:
            return CGSize(width: length2, height: length2)
        }
    }
    
    var designCornerRadius: CGFloat {
        let length1: CGFloat = 60.0
        switch self {
        case .circle:
            return length1/2.0
        case .rectangle:
            return length1/3.0
        case .square:
            return length1/3.0
        }
    }
}

public extension View {
    // 设置图片的大小
    func imageFrame(_ widgetType: ControlWidgetType) -> some View {
        if isInWidget {
            return AnyView(
                self
            )
        } else {
            let size = widgetType.imageSizeInApp
            return AnyView(
                self
                    .frame(width: size.width, height: size.height)
            )
        }
    }
    
    // 设置视图的大小
    func widget_frame_bgColor_cornerRadius(_ widgetType: ControlWidgetType, bgColorString: String) -> some View {
        if isInWidget {
            return AnyView(
                self
                    .background(Color.white)
            )
        } else {
            let size = widgetType.designSizeInApp
            let cornerRadius = widgetType.designCornerRadius
            return AnyView(
                self
                    .frame(width: size.width, height: size.height)
                    .background(Color(hex: bgColorString))
                    .cornerRadius(cornerRadius)
                )
        }
    }
}


public struct StyleSegmentedView: View {
    @State private var options: [ControlWidgetType]
    @Binding var selectedIndex: Int
    var onChangeOfIndex: (Int) -> Void
    
    public init(options: [ControlWidgetType], selectedIndex: Binding<Int>, onChangeOfIndex: @escaping (Int) -> Void) {
        self.options = options
        self._selectedIndex = selectedIndex
        self.onChangeOfIndex = onChangeOfIndex
    }
    
    public var body: some View {
        VStack {
            /*
            // 标题显示当前选中的选项
            Text("Selected Option: \(selectedIndex)")
                .font(.headline)
                .padding()
            */
            
            // 使用 Picker 实现 SegmentedControl
            Picker("Select an Option", selection: $selectedIndex) {
                ForEach(0..<options.count, id: \.self) { index in
                    let option = options[index]
                    Text(option.rawValue)
                        .tag(index) // 使用索引作为 tag
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // 设置为 SegmentedControl 样式
            .onChange(of: selectedIndex) { newValue in
                // 在选项发生变化时输出新的选项
                onChangeOfIndex(newValue)
                print("Selected option: \(options[newValue])")
            }
        }
    }
}

struct StyleSegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        StyleSegmentedView(
            options: ControlWidgetType.allCases,
            selectedIndex: .constant(0),
            onChangeOfIndex: { _ in }
        )
        .padding()
    }
}
