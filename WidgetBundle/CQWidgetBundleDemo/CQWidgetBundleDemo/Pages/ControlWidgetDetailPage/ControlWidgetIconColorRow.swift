//
//  ControlWidgetIconColorRow.swift
//  WidgetIsland
//
//  Created by qian on 2024/12/19.
//

import SwiftUI
import CJViewElement_Swift


struct TSRowDataUtil {
    static func backgroundColorData() -> [CJTextColorDataModel] {
        var colorModels = [
            CJTextColorDataModel(solidColorString: "#000000"),
            CJTextColorDataModel(solidColorString: "#FFFFFF"),
            CJTextColorDataModel(solidColorString: "#2F3F5F"),
            CJTextColorDataModel(solidColorString: "#4E5F82"),
            CJTextColorDataModel(solidColorString: "#7BAD9B"),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#1F625C","#7CB1AE"]),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#74A7CB","#D4CAD4"]),
            CJTextColorDataModel(startPoint: .topLeading,
                                 endPoint: .bottomTrailing,
                                 colorStrings: ["#E5CCEF","#C265D8"]),
            CJTextColorDataModel(startPoint: .topLeading,
                                 endPoint: .bottomTrailing,
                                 colorStrings: ["#B69DEE","#E4D9F3"]),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#503F8B","#BB3D72"]),
            CJTextColorDataModel(startPoint: .top,
                                 endPoint: .bottom,
                                 colorStrings: ["#C5AAAB","#505699"]),
        ]
        
        for (index, model) in colorModels.enumerated() {
            model.id = "\(index)"
            colorModels[index] = model
        }
        return colorModels
    }
    
}
struct ControlWidgetIconColorRow: View {
    var title: String
    var subTitle: String?
    @Binding var colorModel: CJTextColorDataModel
    var onChangeOfColorModel: ((CJTextColorDataModel) -> Void)
    
    @Binding var showRecover: Bool
    var onTapRecover: (() -> Void)
    
    @State var paletteColor: Color = .clear
    let data = ControlWidgetIconColorRow.symbolColorModels()
    
    init(title: String,
         subTitle: String? = nil,
         colorModel: Binding<CJTextColorDataModel>,
         onChangeOfColorModel: @escaping (CJTextColorDataModel) -> Void,
         showRecover: Binding<Bool>,
         onTapRecover: @escaping (() -> Void)
    ) {
        self.title = title
        self.subTitle = subTitle
        self._colorModel = colorModel
        self.onChangeOfColorModel = onChangeOfColorModel
        
        self._showRecover = showRecover
        self.onTapRecover = onTapRecover
    }
    
    /*
    init(iconColorModel: Binding<IconColorModel?>, onChangeOfColorModel: @escaping (CJTextColorDataModel) -> Void) {
        if let wrappedValue = iconColorModel.wrappedValue {
            let colorModel = CJTextColorDataModel(
                index: wrappedValue.index,
                color: CJTextColorDataModel(solidColor: wrappedValue.colorString)
            )
            self._colorModel = .constant(colorModel)
        } else {
            self._colorModel = .constant(CJTextColorDataModel())
        }
        
        self.onChangeOfColorModel = onChangeOfColorModel
    }
    */
    
    var body: some View {
        let scrollViewHeight: CGFloat = 30.0
        
        VStack(alignment: .leading, spacing: 0) {
            ControlWidgetTitleRowView(
                title: title,
                subTitle: subTitle,
                showRecover: $showRecover,
                onTapRecover: {
                    onTapRecover()
                }
            )
            
//            HScrollView(selectedIndex: $colorModel.index, horizontalPadding: (.horizontal, 0), content: {
//                ZStack {
//                    ColorPicker("颜色", selection: $paletteColor, supportsOpacity: false)
//                        .frame(width: 30,height: 30)
//                        .offset(x: -4)
//                        .overlay(
//                            Image("colorPalette")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: (colorModel.index ?? 0) == -2 ? 0 : 30,height: (colorModel.index ?? 0) == -2 ? 0 : 30)
//                                .allowsHitTesting(false)
//                        )
//                }
//                .frame(width: 30, height: 30)
//                
//                ForEach(0..<data.count,id:\.self) { index in
//                    ZStack {
//                        ColorItem(
//                            isSelected: colorModel.index == index,
//                            content: data[index]
//                        )
//                        .onTapGesture {
//                            colorModel = CJTextColorDataModel(index: index, color: data[index])
//                            
//                            onChangeOfColorModel(colorModel)
//                        }
//                        .id(index)
//                        
//                        if index == 0 {
//                            RoundedRectangle(cornerRadius: 15, style: .continuous)
//                                .stroke(lineColor.opacity(1), lineWidth: 1)
//                                .frame(width: 30, height: 30)
//                        }
//                    }
//                }
//            })
//            .frame(height: scrollViewHeight)
//            .padding(.top, 15)
        }
        .onChange(of: paletteColor, perform: { value in
            if value == .clear { return }
            
            let chagneColorIndex = -2
//            let changeColorModel = CJTextColorDataModel(solidColor: value.toHex(includeAlpha: false) ?? "")
//            colorModel = CJTextColorDataModel(index: chagneColorIndex, color: changeColorModel)
            
            onChangeOfColorModel(colorModel)
        })
        .onAppear(perform: {
//            if colorModel.index == -2 {
//                paletteColor = Color(hex: colorModel.color?.solidColor ?? "")
//            }
        })
    }
    
    //TODO: qian
    static func symbolColorModels() -> [CJTextColorDataModel] {
        var colorModels: [CJTextColorDataModel] = [
//            CJTextColorDataModel(startPoint: "topLeading",
//                             endPoint: "bottomTrailing",
//                             colors: ["#FFFFFF"],
//                             solidColor:"#FFFFFF"),
//            
//            CJTextColorDataModel(startPoint: "topLeading",
//                             endPoint: "bottomTrailing",
//                             colors: ["#000000"],
//                             solidColor:"#000000"),
//            
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#2F3F5E"],
//                             solidColor:"#2F3F5E"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#629FBD"],
//                             solidColor:"#629FBD"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#B9C8F6"],
//                             solidColor:"#B9C8F6"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#C4DFF2"],
//                             solidColor:"#C4DFF2"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#CAF0FF"],
//                             solidColor:"#CAF0FF"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#99FFEE"],
//                             solidColor: "#99FFEE"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#B9E1DA"],
//                             solidColor: "#B9E1DA"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#CCEDDF"],
//                             solidColor: "#CCEDDF"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#BBDDBF"],
//                             solidColor: "#BBDDBF"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#B8E7B9"],
//                             solidColor: "#B8E7B9"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#CBECA9"],
//                             solidColor: "#CBECA9"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#E9D998"],
//                             solidColor: "#E9D998"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#D6D088"],
//                             solidColor: "#D6D088"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#EAB679"],
//                             solidColor: "#EAB679"),
//            
//            CJTextColorDataModel(startPoint: "",
//                             endPoint: "",
//                             colors: ["#D08D74"],
//                             solidColor: "#D08D74")
        ]
        for (index, model) in colorModels.enumerated() {
//            model.index = index
            colorModels[index] = model
        }
        return colorModels
    }
}
