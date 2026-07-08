//
//  WidgetClickModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation


public struct IconColorModel: ControlWidgetBaseModel, Hashable, Sendable {
    public static func == (lhs: IconColorModel, rhs: IconColorModel) -> Bool {
        return lhs.index == rhs.index && lhs.colorString == rhs.colorString
    }
    
    var index: Int          // 颜色下标
    public var colorString: String

    public init(index: Int = -1, colorString: String) {
        self.index = index
        self.colorString = colorString
    }

    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case index
        case colorString
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.index = try container.decodeIfPresent(Int.self, forKey: .index) ?? 0
        self.colorString = try container.decode(String.self, forKey: .colorString)
    }
}
