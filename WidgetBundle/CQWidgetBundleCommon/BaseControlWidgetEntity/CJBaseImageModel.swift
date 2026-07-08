//
//  CJBaseImageModel.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import Foundation
import SwiftUI

public struct CJBaseImageModel: Codable, Hashable, Sendable, Identifiable {
    public var id: String               // 图片id
    public var name: String?            // 图片描述名
    public var imageName: String        // 图片地址
    public var imageColorString: String?    // 图标颜色（symbol图标经常使用）
    public var bundleRelativePath: String?  // 图片所在bundle的沙盒相对路径,为nil时候为 Bundle.main
    
    public init(id: String,
                name: String?,
                imageName: String,
                imageColorString: String? = nil,
                bundleRelativePath: String? = "DownloadBundle.bundle"
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.imageColorString = imageColorString
        self.bundleRelativePath = bundleRelativePath
    }
    
    public var downloadBundle: Bundle? {
//        return TSDownloadBundleUtil.getSymbolBundle()
        return nil // 临时用 nil ，因为 TSDownloadBundleUtil 是外部类
    }
    
    public func createUIImage() -> UIImage? {
        let image = UIImage(named: imageName, in: downloadBundle, compatibleWith: nil)
        return image
    }
    
    public func createImageView() -> Image {
        Image(imageName, bundle: downloadBundle)
    }
    
    /// 桌面控制中心选择时候显示
    public func crateDisplayUIImage() -> UIImage? {
        let imageUrl = downloadBundle?.url(forResource: imageName, withExtension: nil)
//        if imageUrl == nil {
//            return nil
//        }
//        let imageData2 = try? Data(contentsOf: imageUrl!)
        
        guard let uiimage = UIImage(named: imageName, in: downloadBundle, with: nil) else {
            return nil
        }
        
        return uiimage
    }
    
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageName
        case imageColorString = "imageColor"
        case bundleRelativePath
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageName = try container.decode(String.self, forKey: .imageName)
        do {
            if let idStringValue = try? container.decode(String.self, forKey: .id) {
                id = idStringValue
            } else {
                if let idIntValue = try container.decodeIfPresent(Int.self, forKey: .id) {
                    id = String(idIntValue)
                } else {
                    id = imageName
                }
            }
        } catch {
            //debugPrint("Failed to decode id: \(error)")
            id = imageName
        }
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
        self.imageName = imageName
        
        self.imageColorString = try container.decodeIfPresent(String.self, forKey: .imageColorString)
        self.bundleRelativePath = try container.decodeIfPresent(String.self, forKey: .bundleRelativePath)
    }
}
