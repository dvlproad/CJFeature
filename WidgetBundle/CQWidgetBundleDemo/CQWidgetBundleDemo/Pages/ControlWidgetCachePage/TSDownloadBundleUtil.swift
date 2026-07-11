//
//  TSDownloadBundleUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/15.
//

import Foundation
import CQWidgetBundleCommon

struct TSDownloadBundleUtil {
    // 图标资源相对路径
    static func updateSymbolsBundleRelativePath(_ relativePath: String) {
        TSCacheUtil.set(relativePath, forKey: "AppGroup_symbolsBundleRelativePath")
    }
    
    static func getSymbolsBundleRelativePath() -> String? {
        let value = TSCacheUtil.stringForKey("AppGroup_symbolsBundleRelativePath")
        return value
    }
    
    static func getSymbolBundle() -> Bundle? {
//        let symbolsBundleRelativePath = getSymbolsBundleRelativePath()
//        return getSymbolsBundle(from: symbolsBundleRelativePath)
        
        //TODO: qian
        var downloadBundle: Bundle?
        let mainBundle: Bundle = Bundle.main
        /*
        if let downloadBundlePath = mainBundle.path(forResource: "WidgetSymbol", ofType: ".bundle") {
            downloadBundle = Bundle(path: downloadBundlePath)
        }
        */
        return downloadBundle
    }
    
    static func getDownloadSymbolDirURL() -> URL {
        let paths = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: TSCacheUtil.ApplicationGroupName)
        return paths!
        
//        return FileManager.default.urls(for:.cachesDirectory, in:.userDomainMask).first!
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory
    }
    
    static func getSymbolsBundle(from downloadBundleRelativePath: String?) -> Bundle? {
        // 获取沙盒的路径（假设文件在应用的文档目录下）
        guard let unzipFileName = downloadBundleRelativePath else {
            return nil
        }
        
        let directoryURL = TSDownloadBundleUtil.getDownloadSymbolDirURL()
        let unzipDirectoryPath = directoryURL.path
        let unzipBundlePath = (unzipDirectoryPath as NSString).appendingPathComponent(unzipFileName)
        let downloadBundle: Bundle? = Bundle.init(path: unzipBundlePath)
        return downloadBundle
        
//        // 拼接出完整路径
//        let documentDirectory = getDownloadSymbolDirURL()
//        let bundleURL = documentDirectory.appendingPathComponent(downloadBundleRelativePath)
//        
//        // 尝试加载 Bundle
//        if let bundle = Bundle(url: bundleURL) {
//            return bundle
//        } else {
//            print("Failed to load bundle at path: \(bundleURL.path)")
//            return nil
//        }
    }
}
