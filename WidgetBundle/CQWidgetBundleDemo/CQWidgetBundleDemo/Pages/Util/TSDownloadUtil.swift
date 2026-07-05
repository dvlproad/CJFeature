//
//  TSDownloadUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/2/5.
//
import SSZipArchive

struct TSDownloadUtil {
    //下载素材
    static func downloadControlSymbols(
        zipUrl: String,
        isEncryption: Bool,
        showLoading: Bool = true,
        success: (() -> Void)?,
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
//        let fileUrl: String = "http://shs4ggs0e.hd-bkt.clouddn.com/symbol/TestDownloadBundle.bundle.zip" //TODO: qian
//        let fileUrl: String = "https://resource.widgetisland.cn/dev/file/upload/20250219/keai.zip"    // 未加密的普通文件夹
//        let fileUrl: String = "http://shs4ggs0e.hd-bkt.clouddn.com/symbol/WidgetIslandSymbol.bundle.zip"
        let fileUrl = zipUrl  // 下载解压后的文件在 getSymbolBundle() 中使用
        
        let zipFileName = (fileUrl as NSString).lastPathComponent               // xxx.bundle.zip
        let unzipFileName = (zipFileName as NSString).deletingPathExtension     // xxx.bundle
        // 判断 unzipFileName 的后缀名是否是 bundle
        if unzipFileName.hasSuffix(".bundle") == false {
            failure("所要下载的图标资源未存放在 .bundle 文件中，会导致 UIImage(named: imageName, in: downloadBundle, with: nil) 中的 downloadBundle 为nil")
            return
        }
        
        let directoryURL = TSDownloadBundleUtil.getDownloadSymbolDirURL()
        
        CJDownloadUtil.downloadFile(
            fileUrl: fileUrl,
            toDirectoryURL: directoryURL,
            saveWithFileName: zipFileName,
            zipDecryptHandle: { (serviceData) in
                if isEncryption {
                    var decryptData = serviceData
                    return serviceData
                    
                } else {
                    return serviceData
                }
            },
            success: { cacheURL in
//                let unzipPath = cacheURL.path.deletingLastPathComponent()
                SSZipArchive.unzipFile(atPath: cacheURL.path, toDestination: directoryURL.path) { (entry, ipInfo, entryNumber, total) in
                    
                } completionHandler: { (path, succeeded, error) in
                    debugPrint("下载控制中心图标资源\(fileUrl)， 解压后的文件为:\(cacheURL)")
                    debugPrint("directoryURL=\(directoryURL.path)")
                    
                    if succeeded {
                        TSDownloadBundleUtil.updateSymbolsBundleRelativePath(unzipFileName)
                        
                        guard isSharedFolderExit(zipFileName) else{
                            failure("解压文件夹名称错误")
                            return
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name("kNoti_Get_NewSymbols"), object: nil)
                        success?()
                    } else {
                        failure("解压文件失败")
                    }
                }
            }, failure: { errorMessage in
                failure(errorMessage)
            }
        )
        return
    }
}

func getDocumentsDirectory() -> URL? {
    let paths = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: TSCacheUtil.ApplicationGroupName)
    if paths != nil{
        return paths!
    }
    return nil
}

func isSharedFolderExit(_ folderName: String) -> Bool {
    guard let documentsDirectory = getDocumentsDirectory() else {
        return false
    }
    let fileManager = FileManager.default
    let documentsUrl = documentsDirectory.appendingPathComponent(folderName)
    guard fileManager.fileExists(atPath: documentsUrl.path) else {
        return false
    }
    
    return true
}
