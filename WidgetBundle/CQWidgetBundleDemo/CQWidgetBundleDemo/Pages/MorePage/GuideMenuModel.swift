//
//  GuideMenuModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/17.
//

import Foundation

@objc public class GuideMenuDataModel: NSObject, Codable {    // 图标库使用UIKit实现，所以这里用 class
    public var id: String               // 图片id
    public var text: String        // 图片地址
    
    public init(id: String,
                text: String
    ) {
        self.id = id
        self.text = text
    }
    
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case text = "name"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let idStringValue = try? container.decode(String.self, forKey: .id) {
                id = idStringValue
            } else {
                let idIntValue = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
                id = String(idIntValue)
            }
        } catch {
            //debugPrint("Failed to decode id: \(error)")
            id = "9999"
        }
        
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
    }
}
