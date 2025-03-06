//
//  CJDownloadUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2024/1/18.
//

import Foundation

struct CJDownloadUtil {
    static func downloadFile(
        fileUrl: String,
        toDirectoryURL: URL,
        saveWithFileName: String,
        zipDecryptHandle: ((_ serviceData: Data) -> (Data?))? = nil,
        success: @escaping ((_ cacheURL: URL) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        guard let fileURL = URL(string: fileUrl) else {
            failure("要下载的文件地址无效，请检查:\(fileUrl)")
            return
        }
        
        // 下载部分
        let downloadTask = URLSession.shared.downloadTask(with: fileURL, completionHandler: { (URL, response: URLResponse?, error) in
            guard let URL = URL, (response as? HTTPURLResponse)?.statusCode == 200 else {
                failure("下载文件失败，请检查:\(fileUrl)")
                return
            }
            
            do {
                let serviceData: Data = try Data(contentsOf: URL)
                let cacheURL = toDirectoryURL.appendingPathComponent(saveWithFileName)
                
                var unencryptData: Data?
                if let decryptBlock = zipDecryptHandle {
                    unencryptData = decryptBlock(serviceData)
                    if unencryptData == nil {
                        failure("加密的文件下载后，解密失败，请检查:\(cacheURL)")
                        return
                    }
                    
                } else {
                    unencryptData = serviceData
                }
                
                do {
                    try ensureDirectoryExists(for: cacheURL)  // 确保文件夹存在
                    try unencryptData?.write(to: cacheURL)  // 写入到缓存
                    success(cacheURL)  // 成功回调
                } catch {
                    failure("加密的文件下载后，保存失败，请检查:\(cacheURL)")  // 写入失败
                }
                
                
                
            } catch {
                failure("文件下载后，读取失败，请检查:\(URL)")
            }
        })
        downloadTask.resume()
    }
    
    // 确保文件夹存在
    static func ensureDirectoryExists(for fileURL: URL) throws {
        let directoryURL = fileURL.deletingLastPathComponent()  // 获取目录路径
        let fileManager = FileManager.default
        
        // 检查目录是否存在
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                // 如果目录不存在，则创建目录
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // 目录创建失败，抛出错误
                throw error
            }
        }
    }
}
