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
        return sets.first!.entitys
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
