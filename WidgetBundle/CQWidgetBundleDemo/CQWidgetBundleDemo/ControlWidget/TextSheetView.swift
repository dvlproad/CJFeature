//
//  TextSheetView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI
import CJAnimationKit_Swift

public struct TextSheetView: View {
    @State private var options: [SymbolEffectType]
    @State var selectedIndex: Int           // 不用 bind ，为了选择结束后能恢复原值
    var onChangeOfIndex: (Int) -> Void
    
    public init(options: [SymbolEffectType], selectedIndex: Int, onChangeOfIndex: @escaping (Int) -> Void) {
        self.options = options
        self.selectedIndex = selectedIndex
        self.onChangeOfIndex = onChangeOfIndex
    }
    
    public var body: some View {
        // Picker for selecting an option
        Picker("Select an Option", selection: $selectedIndex) {
            ForEach(0..<options.count, id: \.self) { index in
                let option = options[index]
                Text(option.description)
                    .tag(index) // 使用索引作为 tag
            }
        }
        .pickerStyle(WheelPickerStyle())
        .onChange(of: selectedIndex) { newValue in
            // 在选项发生变化时输出新的选项
            onChangeOfIndex(newValue)
            print("Selected option: \(options[newValue])")
        }
        .padding()
        
        Spacer()
    }
}
