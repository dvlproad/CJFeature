//
//  IconLinkMenuSectionModel.swift
//  CJListDemo-Swift
//
//  Created by qian on 2025/2/11.
//

import Foundation

class IconLinkMenuSectionModel: NSObject, Codable {
    var categoryModel: GuideMenuDataModel
    var values: [CJBaseImageModel] = [] // Assuming the array should be of a specific type, e.g., CJBaseImageModel
    
    override init() {
        categoryModel = GuideMenuDataModel(id: "", text: "")
        super.init()
    }
    
    // MARK: - Initializer
    init(categoryModel: GuideMenuDataModel, values: [CJBaseImageModel]) {
        self.categoryModel = categoryModel
        self.values = values
    }
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case categoryModel = "categoryInfo"
        case values = "list"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryModel = try container.decodeIfPresent(GuideMenuDataModel.self, forKey: .categoryModel) ?? GuideMenuDataModel(id: "", text: "")
        values = try container.decode([CJBaseImageModel].self, forKey: .values)  // Ensure CJBaseImageModel conforms to Codable
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryModel, forKey: .categoryModel)
        try container.encode(values, forKey: .values)
    }
    
    
    
    static func iconSectionExamples() -> [IconLinkMenuSectionModel] {
        let sections = loadIconSectionFromJSONFile(fileName: "CQControlWidgetColorSymbolSectionExample")
        return sections ?? []
    }
    
    static func loadIconSectionFromJSONFile(fileName: String) -> [IconLinkMenuSectionModel]? {
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
            let items = try decoder.decode([IconLinkMenuSectionModel].self, from: data)
            
            return items
        } catch {
            print("❌Error loading or decoding JSON: \(error)")
            return nil
        }
    }
}
