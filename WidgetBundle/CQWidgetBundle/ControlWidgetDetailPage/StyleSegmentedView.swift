//
//  StyleSegmentedView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI
import CQWidgetBundleCommon // 需要引入 ControlWidgetStyle

public struct StyleSegmentedView: View {
    @State private var options: [ControlWidgetStyle]
    @Binding var selectedIndex: Int
    var onChangeOfIndex: (Int) -> Void
    var onTapHelp: () -> Void
    
    public init(options: [ControlWidgetStyle],
                selectedIndex: Binding<Int>,
                onChangeOfIndex: @escaping (Int) -> Void,
                onTapHelp: @escaping () -> Void
    ) {
        self.options = options
        self._selectedIndex = selectedIndex
        self.onChangeOfIndex = onChangeOfIndex
        self.onTapHelp = onTapHelp
    }
    
    func imageNameForOption(_ option: ControlWidgetStyle) -> String {
        switch option {
        case .circle:
            return "control_circle"
        case .rectangle:
            return "control_rectangle"
        case .square:
            return "control_square"
        }
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            /*
            // 标题显示当前选中的选项
            Text("Selected Option: \(selectedIndex)")
                .font(.headline)
                .padding()
            */
            Spacer()
                .frame(width: 35.0, height: 35.0)
            
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<options.count, id: \.self) { index in
                    let option = options[index]
                    Button(action: {
                        selectedIndex = index
                    }) {
                        //Text(option.rawValue)
                        Image(imageNameForOption(option))
                            .frame(width: 45.5, height: 29)
                            .background(selectedIndex == index ? Color.white : Color.clear) // 选中时背景白色
                            .clipShape(RoundedRectangle(cornerRadius: 29/2.0)) // 圆角
                            //.overlay(
                            //    RoundedRectangle(cornerRadius: 45.5/2.0)
                            //        .stroke(Color.black, lineWidth: 1) // 黑色描边
                            //)
                            .tag(index) // 使用索引作为 tag
                    }
                    .frame(width: 45.5, height: 35, alignment: .center)
                }
            }
            .onChange(of: selectedIndex) { newValue in
                // 在选项发生变化时输出新的选项
                onChangeOfIndex(newValue)
                print("Selected option: \(options[newValue])")
            }
            .frame(width: 146)
            .background(Color(hex: "#EEEEEE"))
            .cornerRadius(35/2.0)
            
            Image("control_help")
                .frame(width: 35.0, height: 35.0)
                .padding(.leading, 0)
                .onTapGesture {
                    onTapHelp()
                }
        }
    }
}

struct StyleSegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        StyleSegmentedView(
            options: ControlWidgetStyle.allCases,
            selectedIndex: .constant(0),
            onChangeOfIndex: { _ in },
            onTapHelp: {}
        )
        .padding()
    }
}
