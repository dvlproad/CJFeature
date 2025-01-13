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
            HStack {
                Button {
                    onCancelBlock()
                } label: {
                    Text("取消")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 44, alignment: .center)
                }
                .background(Color.pink)
                
                Spacer()
                Text("Select an Option")
                    .font(.headline)

                Spacer()
                
                Button {
                    onConfirmBlock(selectedIndex)
                } label: {
                    Text("完成")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 44, alignment: .center)
                }
                .background(Color.pink)
            }
            .padding(.top, 20)
            .background(Color.blue.opacity(0.2))
            
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

struct AnimationSheet_Previews: PreviewProvider {
    static var previews: some View {
        AnimationSheet(
            options: CJAnimationKit_Swift.SymbolEffectType.allCases,
            selectedIndex: 0,
            onChangeOfIndex: { _ in },
            onCancelBlock: {},
            onConfirmBlock: { _ in }
        )
    }
}
