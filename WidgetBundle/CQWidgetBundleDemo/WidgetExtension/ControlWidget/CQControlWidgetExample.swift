//
//  CQControlWidgetIds.swift
//  WidgetExtensionExtension
//
//  Created by qian on 2025/1/11.
//

import Foundation

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
                    imageAnimateType: .woodenFish
                ))
                continue
            } else if index == 4 {
                items.append(BaseControlWidgetEntity(
                    id: diceControlWidgetID,
                    uuid: "uuid_\(index + 1)",
                    title: "骰子title",
                    subTitle: "组件类型",
                    imageName: imageName,
                    imageAnimateType: .none
                ))
                continue
            } else if index == 5 {
                items.append(BaseControlWidgetEntity(
                    id: dynamicIconControlWidgetID,
                    uuid: "uuid_\(index + 1)",
                    title: "旋转动画",
                    subTitle: "组件类型",
                    imageName: imageName,
                    imageAnimateType: .rotate
                ))
                continue
            }
            
            let newItem = BaseControlWidgetEntity(
                id: "id_\(index + 1)",
                uuid: "uuid_\(index + 1)",
                title: "样式\(index + 1)",
                subTitle: "组件类型",
                imageName: imageName,
                imageAnimateType: .none
            )
            items.append(newItem)
        }
        return items
    }
}
