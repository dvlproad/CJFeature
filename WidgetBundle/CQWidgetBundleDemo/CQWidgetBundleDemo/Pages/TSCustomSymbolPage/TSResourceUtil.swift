//
//  TSResourceUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/22.
//

import UIKit

public struct TSResourceUtil {
    static let mainBundlePath = Bundle.main.bundlePath
    static let path_fromMainBundle = Bundle.main.path(forResource: "symbol_svg_inMainBundle", ofType: "svg") ?? ""
    
    // 模拟下载的资源包 URL
    public static var downloadedBundleURL: URL {
        // 使用本地或远程文件 URL
        let bundleURL: URL = Bundle.main.bundleURL.appendingPathComponent("ShareBundle.bundle")
        
//        let imagePath = bundleURL.appendingPathComponent("png_inDesignatedBundle.png").path
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
    
    public static func extractFileNameAndExtension(from fileName: String) -> (fileName: String, fileExtension: String?) {
        if let dotIndex = fileName.lastIndex(of: ".") {
            // 获取扩展名
            let fileExtension = String(fileName[fileName.index(after: dotIndex)...])
            
            // 获取文件名
            let fileNameWithoutExtension = String(fileName[..<dotIndex])
            
            return (fileNameWithoutExtension, fileExtension)
        } else {
            // 如果没有扩展名，返回nil
            return (fileName, nil)
        }
    }

    // 测试
//    let result = extractFileNameAndExtension(from: "aaa.png")
//    print("文件名: \(result.fileName), 扩展名: \(result.fileExtension ?? "无")")

}

import SwiftUI

public struct TSText: View {
    var title: String
    
    public init(_ title: String) {
        self.title = title
    }
    
    public var body: some View {
        VStack {
            Text(title)
                .frame(height: 20)
                .minimumScaleFactor(0.2)
                .multilineTextAlignment(.center)
        }
    }
}
