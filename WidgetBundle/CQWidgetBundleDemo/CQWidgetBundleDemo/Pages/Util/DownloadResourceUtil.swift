//
//  DownloadResourceUtil.swift
//  WidgetIsland
//
//  Created by qian on 2025/2/15.
//

import Foundation
import SSZipArchive

struct DownloadResourceUtil {
    // widgetLayoutFileResource
    static func downloadJsonZip<TModel: Codable>(
        urlStr: String,
        success: @escaping ((TModel) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        let toDestination = getDocumentPathWithWidgetAnimationPath(urlStr.md5())
        let jsonFileURL = toDestination.appendingPathComponent("staticIcon_01.json")
        
        let cacheUrl = FileManager.default.urls(for:.cachesDirectory, in:.userDomainMask).first!.appendingPathComponent(urlStr.md5())
//        if isDyanmicDownUrlPathFolderExit(urlStr.md5()) {///本地已有压缩文件
        if false {
            debugPrint("本地已有解压文件: \(urlStr)")
//            if isDyanmicUnzipUrlPathFolderExit(urlStr.md5()){///本地已有解压文件
//                print(urlStr,Thread.current)
//            }else{
//                unzipDynamic(cacheUrl: cacheUrl, toDestination: toDestination, model: model, dispatchGroup: dispatchGroup, urlStr: urlStr)
//            }
        } else {
            downloadAndUnzipFile(fileName: urlStr.md5(), urlStr: urlStr, isEncryption:true, key: "5zK1JKMnAAj60E5m", success: {
                let toDestination = getDocumentPathWithWidgetAnimationPath(urlStr.md5())
                print("Unzip destination path: \(cacheUrl.path)===\(toDestination.path)")

                SSZipArchive.unzipFile(atPath: cacheUrl.path,
                                       toDestination: toDestination.path) { (entry, ipInfo, entryNumber, total) in
                } completionHandler: { (path, succeeded, error) in
                    print(cacheUrl)
                    print(toDestination.path)
                    if succeeded == false{
//                            self.pageState = .error
                    } else {
                        CJDownloadJsonUtil.parsingJsonFileLocalURL(
                            jsonFileURL,
                            success: { (dataModel: TModel) in
                                success(dataModel)
                            },
                            failure: { errorMessage in
                                failure(errorMessage)
                            }
                        )
                    }
                    
                    delay(0) {
                        SWToast.hideAll()
                    }
                }
                
            }) {
                delay(0) {
                    print("Unzip destinationssadasd path: \(cacheUrl.path)===\(toDestination.path)")
//                    self.pageState = .normal
                    SWToast.hideAll()
                }
            }
        }
    }
    
    static func app_downloadJsonZipUrl<TModel: Codable>(
        _ fileNetworkUrl: String,
        isEncryption: Bool,
        success: @escaping ((TModel) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ){
        let toDirectoryURL = getDocumentPathWithWidgetAnimationPath("ControlWidget").appendingPathComponent(fileNetworkUrl.md5())
//        let saveWithFileName = fileNetworkUrl.md5()
        let upzipFileName = "data.json"
        
        CJDownloadJsonUtil.downloadAndParsingJsonZipUrl(fileNetworkUrl, enableCache: true, toDirectoryURL: toDirectoryURL, zipSaveWithFileName: nil, upzipFileName: upzipFileName, zipDecryptHandle: { (serviceData) in
            if isEncryption {
                var decryptData = serviceData
                return decryptData
                
            } else {
                return serviceData
            }
        }, success: success, failure: failure)
    }
    
    
}

//获取组件json动画解压路径
func getDocumentPathWithWidgetAnimationPath(_ name: String?) -> URL {
    
     //获取沙盒中的 Document 目录路径
     if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
         guard let name = name, name.count > 0 else {
             return documentDirectory
         }
         // 将传入的文件名追加到路径中
//         print("getDocumentPathWithWidgetAnimationPath==\(documentDirectory.appendingPathComponent(name))")
         return documentDirectory.appendingPathComponent(name)
     }else{
         guard let name = name, name.count > 0 else {
             return FileManager.default.temporaryDirectory
         }
         return FileManager.default.temporaryDirectory.appendingPathComponent(name)
     }
}


func delay(_ time: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: block)
}

func downloadAndUnzipFile(fileName: String, urlStr: String,isEncryption:Bool = true,key:String? = nil, success: (() -> Void)?, fail: (() -> Void)?) {
    guard let fileUrl = URL(string: urlStr) else {
        fail?()
        return
    }
    
    // 下载部分
    URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (url, response: URLResponse?, error) in
        guard let url = url, (response as? HTTPURLResponse)?.statusCode == 200 else {
            fail?()
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let cacheUrl = FileManager.default.urls(for:.cachesDirectory, in:.userDomainMask).first!.appendingPathComponent(fileName)
            print("cacheUrl==\(cacheUrl)")
            

                try data.write(to: cacheUrl)
                success?()
            
        } catch {
            fail?()
        }
    }).resume()
}
