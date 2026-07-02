//
//  LinkTextMenuSectionModel.swift
//  WidgetIsland
//
//  Created by qian on 2025/2/11.
//

import Foundation

public class TextLinkMenuSectionModel: NSObject, Codable {
    var categoryModel: GuideMenuDataModel
    var values: [TextLinkMenuDataModel] = [] // Assuming the array should be of a specific type, e.g., CJBaseImageModel
    
    override init() {
        categoryModel = GuideMenuDataModel(id: "", text: "")
        super.init()
    }
    
    // MARK: - Initializer
    init(categoryModel: GuideMenuDataModel, values: [TextLinkMenuDataModel]) {
        self.categoryModel = categoryModel
        self.values = values
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case categoryModel = "categoryInfo"
        case values = "list"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryModel = try container.decodeIfPresent(GuideMenuDataModel.self, forKey: .categoryModel) ?? GuideMenuDataModel(id: "", text: "")
        values = try container.decodeIfPresent([TextLinkMenuDataModel].self, forKey: .values) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryModel, forKey: .categoryModel)
        try container.encode(values, forKey: .values)
    }
    
    static func textSectionExamples() -> [TextLinkMenuSectionModel] {
        let sections = loadTextSectionFromJSONFile(fileName: "CQControlWidgetTextSectionExample")
        return sections ?? []
    }
    
    static func loadTextSectionFromJSONFile(fileName: String) -> [TextLinkMenuSectionModel]? {
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
            let items = try decoder.decode([TextLinkMenuSectionModel].self, from: data)
            
            return items
        } catch {
            print("❌Error loading or decoding JSON: \(error)")
            return nil
        }
    }
}
@objc public class TextLinkMenuDataModel: NSObject, Codable {    // 图标库使用UIKit实现，所以这里用 class
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
        case text = "data"
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

