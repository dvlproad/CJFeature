//
//  CJTestUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//

import Foundation

struct CJTestUtil {
    static func generateRandomImageName() -> String {
        let imageName = imageNames().randomElement()!
        return imageName
    }
    
    static func imageNames() -> [String] {
        var imageNames = ["accessibility-human", "activity"]
        for index in 0...6 {
            imageNames.append("icon_control_katong_\(index%7 + 1)")
        }
        return imageNames
    }
    
    static func generateRandomChineseCharacter() -> String {
        let randomUnicode = Int.random(in: 0x4e00...0x9fa5) // Unicode 范围为 0x4e00 到 0x9fa5
        let scalar = UnicodeScalar(randomUnicode)
        return String(scalar ?? UnicodeScalar(0x4e00)!) // 保证不会返回 nil
    }

    static func generateRandomChineseString(length: Int) -> String {
        var randomString = ""
        for _ in 0..<length {
            randomString.append(generateRandomChineseCharacter())
        }
        return randomString
    }
    
    
    
    // 生成一个随机的中文字符串，长度为 5
//    let randomChineseString = generateRandomChineseString(length: 5)
//    print(randomChineseString)
}

// MARK: 拷贝 Bundle 中的指定文件到共享资源目录下
extension CJTestUtil {
    static var sfsymbolPath_inShareDir = ""
    // 将指定的图片文件从 bundle 复制到共享资源目录
    static func copyImageToSharedDirectory(imageName: String, imageExtension: String, toDirectoryURL: URL) -> String? {
        // 获取原始图片的路径
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: imageExtension) else {
            print("Image not found in bundle")
            return nil
        }
        
        // 创建目标路径（共享资源目录下的目标文件路径）
        let destinationURL = toDirectoryURL.appendingPathComponent("\(imageName).\(imageExtension)")
        
        do {
            // 检查目标文件是否已存在，如果存在则删除它
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            // 将图片从源目录复制到共享目录
            try FileManager.default.copyItem(at: imageURL, to: destinationURL)
            print("Image copied to shared directory: \(destinationURL.path)")
            return destinationURL.path
        } catch {
            print("Failed to copy image: \(error.localizedDescription)")
            return nil
        }
    }
}
