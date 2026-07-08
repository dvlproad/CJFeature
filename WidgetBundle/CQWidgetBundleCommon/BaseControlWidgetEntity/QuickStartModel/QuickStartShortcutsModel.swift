//
//  QuickStartShortcutsModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation

public struct QuickStartShortcutsModel: ControlWidgetBaseModel, Hashable, Equatable {
    public var shortcutsName: String
    var shortcutsText: String?
    
    public var targetUrl: String
    
    public init(shortcutsName: String, shortcutsText: String? = nil, targetUrl: String) {
        self.shortcutsName = shortcutsName
        self.shortcutsText = shortcutsText
        self.targetUrl = targetUrl
    }
    
    /*
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case shortcutsName
        case shortcutsText
        case targetUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.shortcutsName = try container.decode(String.self, forKey: .shortcutsName)
        self.shortcutsText = try container.decodeIfPresent(String.self, forKey: .shortcutsText)
        self.targetUrl = try container.decode(String.self, forKey: .targetUrl)
    }
    */
}
