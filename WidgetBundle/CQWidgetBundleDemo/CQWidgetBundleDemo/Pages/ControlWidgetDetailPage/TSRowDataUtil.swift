//
//  TSRowDataUtil.swift
//  CJViewCreatorDemo
//
//  Created by qian on 2024/12/19.
//

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
