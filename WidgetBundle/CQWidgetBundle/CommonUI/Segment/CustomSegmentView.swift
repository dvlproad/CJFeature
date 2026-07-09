//
//  CustomSegmentView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import SwiftUI

public class BaseSegmentModel: NSObject {
    public var segmentId: String
    
    public var text: String
    public var textFontSize: CGFloat
    
    public var width: CGFloat
    
    public init(segmentId: String, text: String, textFontSize: CGFloat, width: CGFloat) {
        self.segmentId = segmentId
        self.text = text
        self.textFontSize = textFontSize
        self.width = width
    }
}

struct CustomSegmentView: View {
    let options: [BaseSegmentModel]
    @Binding var currentSelectedModel: BaseSegmentModel?
    var height: CGFloat // 视图的高度
    var onChangeOfModel: ((BaseSegmentModel) -> Void)
    
    
    var body: some View {
        let totalWidth = options.reduce(0) { $0 + $1.width }

        HStack{
            HStack(alignment: .center, spacing: 0) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    let isSelected: Bool = option.segmentId == currentSelectedModel?.segmentId
                    CustomSegmentButton(option: option, isSelected: isSelected, height: height-3)
                        .onTapGesture {
//                            currentSelectedModel = option
                            onChangeOfModel(option)
                        }
                }
            }
            .frame(width: totalWidth + 2, height: height, alignment: .center)
            .background(Color(hex: "#F5F5F5"))
            .cornerRadius(height / 2)
        }
    }
}

struct CustomSegmentButton: View {
    let option: BaseSegmentModel
    var isSelected: Bool
    
    let height: CGFloat

    var body: some View {
        Text(option.text)
            .font(.system(size: option.textFontSize, weight: .medium))
            .foregroundColor(Color(hex: isSelected ? "#333333" : "#999999"))
            .frame(width: option.width, height: height, alignment: .center)
            .background(Color(hex: isSelected ? "#FFFFFF" : "#F5F5F5"))
            .cornerRadius(height / 2)
    }
}
