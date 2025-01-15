//
//  TSWidgetResourceCacheUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//
// 控制中心组件中的资源文件的缓存（图标等）

import UIKit

struct TSWidgetResourceCacheUtil {
    // 获取 App Group 共享目录路径
    static func getSharedDirectory() -> URL? {
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: TSCacheUtil.ApplicationGroupName) else {
            print("Failed to access App Group directory")
            return nil
        }
        return groupURL
    }
    
    static func loadSharedImageName(_ imageName: String) -> UIImage? {
        guard let sharedDirectory = getSharedDirectory() else { return nil }

        // 拼接图片路径
        let imageURL = sharedDirectory.appendingPathComponent(imageName)
        // 尝试加载图片
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    static func copyImageToSharedDirectory(imageName: String, imageExtension: String) -> String? {
        guard let sharedDirectory = getSharedDirectory() else { return nil }
        CJLogUtil.log("共享资源目录的路径是:\(sharedDirectory)")
        
        return CJTestUtil.copyImageToSharedDirectory(
            imageName: imageName,
            imageExtension: imageExtension,
            toDirectoryURL: sharedDirectory
        )
    }
    
    static func saveImageToSharedDirectory(image: UIImage, imageName: String) -> Bool {
        guard let sharedDirectory = getSharedDirectory() else { return false }
        
        // 创建图片文件路径
        let imageURL = sharedDirectory.appendingPathComponent(imageName)
        
        // 将图片保存为PNG格式
        if let data = image.pngData() {
            do {
                try data.write(to: imageURL)
                print("Image saved successfully to: \(imageURL.path)")
                return true
            } catch {
                print("Failed to save image: \(error.localizedDescription)")
                return false
            }
        }
        return false
    }
}
