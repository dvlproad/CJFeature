//
//  ControlWidgetPreviewModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation
/*
 {
       "componentCategory": null,
       "componentId": 2,
       "componentName": "2222",
       "configFile": "https://resource.widgetisland.cn/dev/component/config/2025-02-11/87f73a62-3d10-41c0-beac-f9b07344c09b.zip",
       "imageList": [
         "https://resource.widgetisland.cn/dev/image/2025-02-11/a40c0957-5b03-4810-8609-ceeca427f5c7.webp",
         "https://resource.widgetisland.cn/dev/image/2025-02-11/886b1595-99ee-4336-bc52-c529e1eaff52.png",
         "https://resource.widgetisland.cn/dev/image/2025-02-11/72785103-899f-41ed-8182-c8786bba7d19.png",
         "https://resource.widgetisland.cn/dev/image/2025-02-11/979ff4fa-2ce5-41ca-8859-e78098e42586.png"
       ],
       "type": 1
     },
 */

enum ControlWidgetPreviewType: Int, Codable {
    case component = 0  // 0组件
    case set = 1        // 1套图
}

public class ControlWidgetPreviewModels: NSObject, Codable {
    var models: [ControlWidgetPreviewModel]
    
    init(models: [ControlWidgetPreviewModel]) {
        self.models = models
    }
}

public class ControlWidgetPreviewItemModel: NSObject, Codable {
    var imageUrl: String
    var zipUrl: String
    
    public init(imageUrl: String, zipUrl: String) {
        self.imageUrl = imageUrl
        self.zipUrl = zipUrl
    }
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case imageUrl
        case zipUrl
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
        zipUrl = try container.decodeIfPresent(String.self, forKey: .zipUrl) ?? ""
    }
}

public class ControlWidgetPreviewModel: NSObject, Codable {
    var componentCategory: ControlWidgetType
    var id: String
    public var name: String
    var configFile: String?
    var type: ControlWidgetPreviewType   //数据分类 0组件; 1套图
    var style: ControlWidgetStyle   // 类型
    var entitys: [ControlWidgetPreviewItemModel]    // 组件的数据
    var groupModels: [ControlWidgetPreviewModel]    // 套图的数据
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case componentCategory = "componentCategory"
        case id = "componentId"
        case name = "componentName"
        case configFile = "configFile"
        case entitys = "imageList"
        case type = "type"
        case style = "componentShape"
        case groupModels = "kitScopeList"
    }
    
    public override init() {
        self.componentCategory = .unknown
        self.id = ""
        self.name = ""
        self.configFile = nil
        self.entitys = []
        self.groupModels = []
        self.type = .component
        self.style = .circle
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let serviceComponentCategory = try container.decodeIfPresent(ControlWidgetCategory.self, forKey: .componentCategory) ?? .unknown
        componentCategory = serviceComponentCategory.toControlWidgetType()
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
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        configFile = try container.decodeIfPresent(String.self, forKey: .configFile)
        
        let imageUrls = try container.decodeIfPresent([String].self, forKey: .entitys) ?? []
        entitys = imageUrls.map { ControlWidgetPreviewItemModel(imageUrl: $0, zipUrl: "") }
        
        groupModels = try container.decodeIfPresent([ControlWidgetPreviewModel].self, forKey: .groupModels) ?? []
        
        let typeIValue = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        type = ControlWidgetPreviewType(rawValue: typeIValue) ?? ControlWidgetPreviewType.component
        
        let styleIValue = try container.decodeIfPresent(Int.self, forKey: .style) ?? 1   // 1、圆形 2、矩形
        if styleIValue == 2 {
            style = .rectangle
        } else {
            style = .circle
        }
    }
}
