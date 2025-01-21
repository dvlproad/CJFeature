//
//  TSResourceUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/22.
//

import UIKit

public struct TSResourceUtil {
    // 模拟下载的资源包 URL
    public static var downloadedBundleURL: URL {
        // 使用本地或远程文件 URL
        let bundleURL: URL = Bundle.main.bundleURL.appendingPathComponent("ShareBundle.bundle")
        
//        let imagePath = bundleURL.appendingPathComponent("app_search_icon_byBundlePath.png").path
//        print("Image path: \(imagePath), exists: \(FileManager.default.fileExists(atPath: imagePath))")
        
        return bundleURL
    }
    
    public static var downloadedBundle: Bundle? {
        let downloadedBundle = Bundle(url: downloadedBundleURL)
        return downloadedBundle
    }
    
    public static func downloadedBundle_UIImage(name: String) -> UIImage? {
        if let bundleURL = downloadedBundle?.resourceURL {
            let imagePath = bundleURL.appendingPathComponent(name).path
            if let uiImage = UIImage(contentsOfFile: imagePath) {
                print("Image loaded successfully.")
                return uiImage
            } else {
                print("Failed to load image.")
                return nil
            }
        }
        return nil
    }
}
