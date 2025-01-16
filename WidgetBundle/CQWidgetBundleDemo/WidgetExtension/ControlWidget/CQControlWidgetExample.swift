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
    // 基本
    // 使用一个风扇图标，点击后在旋转和不旋转间切换
    static let fanControlWidgetID = "fan"           // 风扇
    // 点击后更换图标及文字
    static let diceControlWidgetID = "dice"         // 骰子
    
    static let dynamicIconControlWidgetID = "dynamicIcon"  // 动态图标
    
    // 执行
    // 点击可以打开其它的应用
    static let openAppControlWidgetID = "open_app"              // 应用（日历）
    // 点击可以运行指定的快捷指令
    static let openBluetoothControlWidgetID = "open_bluetooth"  // 快捷指令（蓝牙）
    // 点击可以打开指定的网页
    static let openWebControlWidgetID = "open_web"              // 网页（掘金）
    
    // 其他自定义
    // 使用一个木鱼图标，点击后图标实现点击动画、可播放声音
    static let meritsWoodenFishControlWidgetID = "meritsWoodenFish"  // 功德木鱼
    
    /*
    * 点击后实现震动效果
    * 点击后可以打开实时活动(灵动岛)
    */
    
    
    
    static func examples() -> [BaseControlWidgetEntity] {
        var items: [BaseControlWidgetEntity] = []
        let fixEntitys: [BaseControlWidgetEntity] = [
            fanEntity(),
            diceEntity(),
            dynamicIconEntity(),
            
            openAppEntity(),
            openBluetoothEntity(),
            openWebEntity(),
            
            woodenFishEntity(),
        ]
        items.append(contentsOf: fixEntitys)
        
        // 创建20个item
        let imageNames = CJTestUtil.imageNames()
        for index in (fixEntitys.count-1)...19 {
            let imageName = imageNames[index%(imageNames.count)]
            let newItem = BaseControlWidgetEntity(
                id: "id_\(index + 1)",
                title: "样式\(index + 1)",
                subTitle: "组件类型",
                imageModel: CJBaseImageModel(id: "id_\(index + 1)", name: "", imageName: imageName),
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
    
    // MARK: 基本
    static func fanEntity() -> BaseControlWidgetEntity {
        return BaseControlWidgetEntity(
            id: fanControlWidgetID,
            title: "风扇",
            subTitle: "关闭",
            imageModel: CJBaseImageModel(
                id: "imageId_\(fanControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_1"
            ),
            imageAnimateType: .woodenFish,
            name: "风扇",
            widgetStyle: .rectangle,
            bgColorString: "#ff0000"
        )
    }
    static func diceEntity() -> BaseControlWidgetEntity {
        return BaseControlWidgetEntity(
            id: diceControlWidgetID,
            title: "骰子title",
            subTitle: "组件类型",
            imageModel: CJBaseImageModel(
                id: "imageId_\(diceControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_2"
            ),
            imageAnimateType: .rotate,
            name: "骰子",
            widgetStyle: .rectangle,
            bgColorString: "#ff0000"
        )
    }
    static func dynamicIconEntity() -> BaseControlWidgetEntity {
        return BaseControlWidgetEntity(
            id: dynamicIconControlWidgetID,
            title: "旋转动画",
            subTitle: "组件类型",
            imageModel: CJBaseImageModel(
                id: "imageId_\(dynamicIconControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_3"
            ),
            imageAnimateType: .rotate,
            name: "旋转",
            widgetStyle: .rectangle,
            bgColorString: "#ff0000"
        )
    }
    
    // MAKR: 执行
    static func openAppEntity() -> BaseControlWidgetEntity {
        var entity = BaseControlWidgetEntity(
            id: openAppControlWidgetID,
            title: "日历",
            subTitle: "关闭",
            imageModel: CJBaseImageModel(
                id: "imageId_\(openAppControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_4"
            ),
            imageAnimateType: .none,
            name: "日历",
            widgetStyle: .rectangle,
            bgColorString: "#00FF00"
        )
        entity.appModel = QuickStartAppModel.calshowAppModel()
        return entity
    }
    static func openBluetoothEntity() -> BaseControlWidgetEntity {
        var entity = BaseControlWidgetEntity(
            id: openBluetoothControlWidgetID,
            title: "蓝牙",
            subTitle: "关闭",
            imageModel: CJBaseImageModel(
                id: "imageId_\(openBluetoothControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_5"
            ),
            imageAnimateType: .none,
            name: "蓝牙",
            widgetStyle: .rectangle,
            bgColorString: "#00FF00"
        )
        entity.appModel = QuickStartAppModel.shortcutsUrlModel()
        return entity
    }
    
    static func openWebEntity() -> BaseControlWidgetEntity {
        var entity = BaseControlWidgetEntity(
            id: openWebControlWidgetID,
            title: "稀土掘金",
            subTitle: "关闭",
            imageModel: CJBaseImageModel(
                id: "imageId_\(openWebControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_6"
            ),
            imageAnimateType: .none,
            name: "稀土掘金",
            widgetStyle: .rectangle,
            bgColorString: "#00FF00"
        )
        entity.appModel = QuickStartAppModel.openWebAppModel()
        return entity
    }
    
    // MARK: 自定义
    static func woodenFishEntity() -> BaseControlWidgetEntity {
        return BaseControlWidgetEntity(
            id: meritsWoodenFishControlWidgetID,
            title: "x0",
            subTitle: "功德+1",
            imageModel: CJBaseImageModel(
                id: "imageId_\(meritsWoodenFishControlWidgetID)",
                name: "",
                imageName: "icon_control_katong_7"
            ),
            imageAnimateType: .woodenFish,
            name: "木鱼",
            widgetStyle: .rectangle,
            bgColorString: "#0000FF"
        )
    }
}

struct CQControlWidgetExample {
    static func iconExamples() -> [CJBaseImageModel] {
        var items: [CJBaseImageModel] = []
        
        let exampleDataModels = CQControlWidgetIds.examples()
        for item in exampleDataModels {
            items.append(item.imageModel)
        }
        return items
    }
}
