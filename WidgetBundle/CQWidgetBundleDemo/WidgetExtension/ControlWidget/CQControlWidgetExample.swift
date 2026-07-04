//
//  CQControlWidgetIds.swift
//  WidgetExtensionExtension
//
//  Created by qian on 2025/1/11.
//

import Foundation
import SwiftUI

struct CQControlWidgetIds {
    
    static func examples() -> [BaseControlWidgetEntity] {
        let sets: [BaseControlWidgetSetModel] = exampleSetsFromJson()

        let targetWidgetIds: Set<String> = [
            "staticIcon_01",
            "dynamicIcon_supportstick",
            "dynamicIcon_cat",
            "open_app",
            "open_bluetooth",
            "open_web",
            "state_open_app",
            "state_open_bluetooth",
            "state_open_web",
            "dice",
            "meritsWoodenFish",
            "voice"
        ]
        return sets.flatMap { $0.entitys }
                   .filter { targetWidgetIds.contains($0.widgetId) }
    }
    /*
    * 点击后实现震动效果
    * 点击后可以打开实时活动(灵动岛)
    */
    
    static func loadSetJSONFromFile(fileName: String) -> [BaseControlWidgetSetModel]? {
        // 获取文件路径
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("File not found: \(fileName).json")
            return nil
        }
        
        do {
            // 读取文件内容
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            
            // 使用 JSONDecoder 序列化数据
            let decoder = JSONDecoder()
            let sets = try decoder.decode([BaseControlWidgetSetModel].self, from: data)
            
            return sets
        } catch {
            print("❌Error loading or decoding JSON: \(error)")
            return nil
        }
    }
    
    static func exampleSetsFromJson() -> [BaseControlWidgetSetModel] {
        if let sets = loadSetJSONFromFile(fileName: "CQControlWidgetSetExample") {
//            for item in items {
//                print("ID: \(item.id), Name: \(item.name)")
//            }
            return sets
        } else {
            return []
        }
    }
    
    
    static func loadJSONFromFile(fileName: String) -> [BaseControlWidgetEntity]? {
        // 获取文件路径
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("File not found: \(fileName).json")
            return nil
        }
        
        do {
            // 读取文件内容
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            
            // 使用 JSONDecoder 序列化数据
            let decoder = JSONDecoder()
            let items = try decoder.decode([BaseControlWidgetEntity].self, from: data)
            
            return items
        } catch {
            print("❌Error loading or decoding JSON: \(error)")
            return nil
        }
    }
}
