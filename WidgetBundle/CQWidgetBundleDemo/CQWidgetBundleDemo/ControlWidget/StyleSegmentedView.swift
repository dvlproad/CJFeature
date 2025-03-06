//
//  StyleSegmentedView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI

public enum ControlWidgetCategory: String, Sendable, Codable {
    case unknown            // 位置组件
    case toggle_icon = "0"  // 图标组件
    case open_app = "1"     // 快捷启动应用
//    case open_shortcut      // 快捷指令
//    case audio =  "2"       // 音频
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = ControlWidgetCategory(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .unknown
        }
    }
    
    public func toControlWidgetType() -> ControlWidgetType {
        switch self {
        case .unknown:
            return .unknown
        case .toggle_icon:
            return .toggle_icon
        case .open_app:
            return .open_app
//        case .audio:
//            return .audio
        }
    }
}

public enum ControlWidgetType: String, Sendable, Codable {
//    case toogle         // 有开关状态的图标组件
//    case quickStart     // 快捷启动
    
    case unknown            // 位置组件
    case toggle_icon        // 图标组件
    case open_app           // 快捷启动应用
    case open_shortcut      // 快捷指令
    case audio              // 音频组件
//    case woodenFish         // 木鱼
//    case dice               // 骰子
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = ControlWidgetType(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .unknown
        }
    }
}


public enum ControlWidgetStyle: String, Sendable, CaseIterable, Codable {
    case circle     // 圆形
    case rectangle  // 长方形
    case square     // 正方形
    
    // 在 app 内时候，该组件中的图片的大小
    var imageSizeInApp: CGSize {
        // 【【控制中心】组件详情显示的图标，需要调整大一点，目前有点小。】 https://www.tapd.cn/tapd_fe/66656887/bug/detail/1166656887001001690
        let length1: CGFloat = 66.0
        return CGSize(width: length1 * 0.6, height: length1 * 0.6) // ≈40
        /*
        switch self {
        case .circle:
            return CGSize(width: 36, height: 36)
        case .rectangle:
            return CGSize(width: 36, height: 36)
        case .square:
            return CGSize(width: 48, height: 48)
        }
        */
    }
    
    // 在 app 内时候，该组件中的图片的大小
    var designSizeInApp: CGSize {
        let length1: CGFloat = 66.0
        let length2: CGFloat = 145.0
        switch self {
        case .circle:
            return CGSize(width: length1, height: length1)
        case .rectangle:
            return CGSize(width: length2, height: length1)
        case .square:
            return CGSize(width: 150.0, height: 150.0)
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
    
    //MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取字符串值
        let rawValue = try container.decode(String.self)
        
        // 如果枚举值存在，则正常初始化
        if let validValue = ControlWidgetStyle(rawValue: rawValue) {
            self = validValue
        } else {
            // 如果是无效的值（例如 "normal"），则默认使用 .toogle
            self = .circle
        }
    }
}

public extension View {
    // 设置图片的大小
    func imageFrame(_ size: CGSize) -> some View {
        if isInWidget {
            return AnyView(
                self
            )
        } else {
            return AnyView(
                self
                    .frame(width: size.width, height: size.height)
            )
        }
    }
    
    // 设置视图的大小
    func widget_frame_bgColor_cornerRadius(size: CGSize, bgColor: Color, cornerRadius: CGFloat, borderColor: Color?, borderWidth: CGFloat?) -> some View {
        if isInWidget {
            return AnyView(
                self
                    .background(Color.white)
            )
        } else {
            return AnyView(
                self
                    .frame(width: size.width, height: size.height)
                    .background(bgColor)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor ?? Color.clear, lineWidth: borderWidth ?? 0)
                    )
                )
        }
    }
}


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
