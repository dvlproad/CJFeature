//
//  CQControlWidgetIds.swift
//  WidgetExtensionExtension
//
//  Created by qian on 2025/1/11.
//

import Foundation
import SwiftUI
import CJViewElement_Swift
import CJAnimationKit_Swift

struct CQControlWidgetIds {
    static let meritsWoodenFishControlWidgetID = "meritsWoodenFish"  // 功德
    static let diceControlWidgetID = "dice"  // 骰子
    static let dynamicIconControlWidgetID = "dynamicIcon"  // 动态图标
    
    
    static func examples() -> [BaseControlWidgetEntity] {
        var items: [BaseControlWidgetEntity] = []
        // 创建20个item
        let imageNames = CJTestUtil.imageNames()
        for index in 0...19 {
            let imageName = imageNames[index%(imageNames.count)]
            if index == 3 {
                items.append(BaseControlWidgetEntity(
                    id: meritsWoodenFishControlWidgetID,
                    uuid: "uuid_\(index + 1)",
                    title: "x0",
                    subTitle: "功德+1",
                    imageName: imageName,
                    imageAnimateType: .woodenFish,
                    name: "木鱼",
                    widgetStyle: .circle,
                    bgColorString: "#ff0000"
                ))
                continue
            } else if index == 4 {
                items.append(BaseControlWidgetEntity(
                    id: diceControlWidgetID,
                    uuid: "uuid_\(index + 1)",
                    title: "骰子title",
                    subTitle: "组件类型",
                    imageName: imageName,
                    imageAnimateType: .none,
                    name: "骰子",
                    widgetStyle: .circle,
                    bgColorString: "#00FF00"
                ))
                continue
            } else if index == 5 {
                items.append(BaseControlWidgetEntity(
                    id: dynamicIconControlWidgetID,
                    uuid: "uuid_\(index + 1)",
                    title: "旋转动画",
                    subTitle: "组件类型",
                    imageName: imageName,
                    imageAnimateType: .rotate,
                    name: "旋转",
                    widgetStyle: .circle,
                    bgColorString: "#0000FF"
                ))
                continue
            }
            
            let newItem = BaseControlWidgetEntity(
                id: "id_\(index + 1)",
                uuid: "uuid_\(index + 1)",
                title: "样式\(index + 1)",
                subTitle: "组件类型",
                imageName: imageName,
                imageAnimateType: randomAnimateType(),
                name: "名称\(index + 1)",
                widgetStyle: randomWidgetStyle(),
                bgColorString: randomColorString()
            )
            items.append(newItem)
        }
        return items
    }
    
    static func randomWidgetStyle() -> ControlWidgetType {
        //return ControlWidgetType.allCases.randomElement()!
        return [.circle, .rectangle].randomElement()!
    }
    
    static func randomAnimateType() -> AnimationType {
        return AnimationType.allCases.randomElement()!
    }
    
    static func randomColorString() -> String {
        return Color.randomColor.toHex(includeAlpha: true) ?? "#ff0000"
    }
    
    
}

struct CQControlWidgetExample {
    static func iconExamples() -> [CJBaseDataModel] {
        var items: [CJBaseDataModel] = []
        // 创建20个item
        let imageNames = CJTestUtil.imageNames()
        for index in 0...19 {
            let imageName = imageNames[index%(imageNames.count)]
            let newItem = CJBaseDataModel(
                id: "id_\(index + 1)",
                name: "样式\(index + 1)",
                egImage: imageName
            )
            items.append(newItem)
        }
        return items
    }
}
