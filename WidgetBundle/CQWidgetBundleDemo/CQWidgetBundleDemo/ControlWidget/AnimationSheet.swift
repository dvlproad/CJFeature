//
//  AnimationSheet.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI
import CJAnimationKit_Swift

public struct AnimationSheet: View {
    @State private var options: [SymbolEffectType]
    @State var selectedIndex: Int           // 不用 bind ，为了选择结束后能恢复原值
    var onChangeOfIndex: (Int) -> Void
    var onCancelBlock: () -> Void
    var onConfirmBlock: (Int) -> Void
    
    public init(options: [SymbolEffectType], selectedIndex: Int, onChangeOfIndex: @escaping (Int) -> Void, onCancelBlock: @escaping () -> Void, onConfirmBlock: @escaping (_ newSelectedIndex: Int) -> Void) {
        self.options = options
        self.selectedIndex = selectedIndex
        self.onChangeOfIndex = onChangeOfIndex
        self.onCancelBlock = onCancelBlock
        self.onConfirmBlock = onConfirmBlock
    }
    
    public var body: some View {
        VStack {
            SheetToolbarView(
                title: "选择动画",
                onCancelBlock: onCancelBlock,
                onConfirmBlock: {
                    onConfirmBlock(selectedIndex)
                }
            )
            
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
}


public struct AnimationSheetView: View {
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
        VStack(alignment: .center, spacing: 0) {
            Picker("Select an Option", selection: $selectedIndex) {
                ForEach(0..<options.count, id: \.self) { index in
                    let option = options[index]
                    Text(option.description)
                        .tag(index) // 使用索引作为 tag
                }
            }
            .pickerStyle(WheelPickerStyle())
            //.background(Color.blue)
            .onChange(of: selectedIndex) { newValue in
                // 在选项发生变化时输出新的选项
                onChangeOfIndex(newValue)
                print("Selected option: \(options[newValue])")
            }
            
            Spacer() // 确保从底部弹出的视图上，picker是从顶部开始布局的
        }
    }
}

public struct SheetToolbarView: View {
    var title: String
    var onCancelBlock: () -> Void
    var onConfirmBlock: () -> Void
    
    public init(title: String, onCancelBlock: @escaping () -> Void, onConfirmBlock: @escaping () -> Void) {
        self.title = title
        self.onCancelBlock = onCancelBlock
        self.onConfirmBlock = onConfirmBlock
    }
    
    public var body: some View {
        HStack {
            Button {
                onCancelBlock()
            } label: {
                Text("取消")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#333333"))
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 44, alignment: .center)
            }
            //.background(Color.pink)
            
            Spacer()
            Text(title)
                .font(.headline)

            Spacer()
            
            Button {
                onConfirmBlock()
            } label: {
                Text("完成")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 44, alignment: .center)
            }
            //.background(Color.pink)
        }
        //.background(Color.blue.opacity(0.2))
    }
}

struct AnimationSheet_Previews: PreviewProvider {
    static var previews: some View {
        AnimationSheet(
            options: SymbolEffectType.allCases,
            selectedIndex: 0,
            onChangeOfIndex: { _ in },
            onCancelBlock: {},
            onConfirmBlock: { _ in }
        )
    }
}
