//
//  CustomSegmentView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import SwiftUI

class BaseSegmentModel: NSObject {
    var segmentId: String
    
    var text: String
    var textFontSize: CGFloat
    
    var width: CGFloat
    
    init(segmentId: String, text: String, textFontSize: CGFloat, width: CGFloat) {
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
            HStack(spacing: 0) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    let isSelected: Bool = option.segmentId == currentSelectedModel?.segmentId
                    CustomSegmentButton(option: option, isSelected: isSelected, height: height)
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
        .padding(.horizontal, 21)
    }
}

struct CustomSegmentButton: View {
    let option: BaseSegmentModel
    var isSelected: Bool
    
    let height: CGFloat

    var body: some View {
        Text(option.text)
            .font(.system(size: option.textFontSize, weight: .medium))
            .foregroundColor(Color(hex: isSelected ? "#666666" : "#333333"))
            .frame(width: option.width, height: height, alignment: .center)
            .background(Color(hex: isSelected ? "#FFFFFF" : "#F5F5F5"))
            .cornerRadius(height / 2)
    }
}
