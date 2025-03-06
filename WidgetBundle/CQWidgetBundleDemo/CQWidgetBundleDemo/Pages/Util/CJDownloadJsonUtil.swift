//
//  CJDownloadJsonUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2024/1/18.
//

import Foundation
import SSZipArchive
import SwiftyJSON

public class DownloadResponseModel<TModel: Codable>: NSObject {
    var errorMessage: String?
    var dataModel: TModel?
    
    public init(errorMessage: String? = nil, dataModel: TModel? = nil) {
        self.errorMessage = errorMessage
        self.dataModel = dataModel
    }
}

public struct CJDownloadJsonUtil {
    public static func getZipNameWithoutExtension(zipPathOrUrl: String) -> String {
        var zipName: String
        if let jsonZipNetworkURL = URL(string: zipPathOrUrl) {
            zipName = jsonZipNetworkURL.lastPathComponent
        } else {
            zipName = "unknown_jsonZipName.zip"
        }
        
        let zipNameWithoutExtension: String = (zipName as NSString).deletingPathExtension
        return zipNameWithoutExtension
    }
    
    
    public static func downloadAndParsingJsonZipUrl<TModel: Codable>(
        _ jsonZipNetworkUrl: String,
        enableCache: Bool,  // 是否允许缓存，false则每次都重新下载zip并解压和解析
        toDirectoryURL: URL,    // zip和unzip都存在这个目录下
        zipSaveWithFileName: String?,   // 解压前把zip以什么名字保存到本地（为nil时候使用后台自身文件名）
        upzipFileName: String,          // 解压之后得到的文件名（请确保本值为解压之后的实际名字）
        zipDecryptHandle: ((_ serviceData: Data) -> (Data?))? = nil,
        zipProgressHandler: ((_ progressValue: CGFloat) -> Void)? = nil,
        success: @escaping ((TModel) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
        let jsonFileLocalURL = toDirectoryURL.appendingPathComponent(upzipFileName)
        
        if enableCache, FileManager.default.fileExists(atPath: jsonFileLocalURL.path) {
            parsingJsonFileLocalURL(jsonFileLocalURL, success: { (dataModel: TModel) in
                success(dataModel)
            },failure: { errorMessage in
                failure(errorMessage)
            })
        } else {
            downloadJsonZipUrl(jsonZipNetworkUrl, toDirectoryURL: toDirectoryURL, zipSaveWithFileName: zipSaveWithFileName, upzipFileName: upzipFileName, zipDecryptHandle: zipDecryptHandle, success: { unzipLocalURL in
                parsingJsonFileLocalURL(unzipLocalURL, success: { (dataModel: TModel) in
                    success(dataModel)
                },failure: { errorMessage in
                    failure(errorMessage)
                })
            }, failure: failure)
        }
    }
    
    public static func downloadJsonZipUrl(
        _ jsonZipNetworkUrl: String,
        toDirectoryURL: URL,
        zipSaveWithFileName: String?,   // 解压前把zip以什么名字保存到本地（为nil时候使用后台自身文件名）
        upzipFileName: String,          // 解压之后得到的文件名（请确保本值为解压之后的实际名字）
        zipDecryptHandle: ((_ serviceData: Data) -> (Data?))? = nil,
        zipProgressHandler: ((_ progressValue: CGFloat) -> Void)? = nil,
        success: @escaping ((_ unzipLocalURL: URL) -> Void),
        failure: @escaping ((_ errorMessage: String) -> Void)
    ) {
//        let unzipLocalURL = toDirectoryURL.appendingPathComponent(upzipFileName)

        var zipName: String
        if let zipSaveWithFileName = zipSaveWithFileName, zipSaveWithFileName.count > 0 {
            zipName = zipSaveWithFileName
        } else {
            if let jsonZipNetworkURL = URL(string: jsonZipNetworkUrl) {
                zipName = jsonZipNetworkURL.lastPathComponent
            } else {
                zipName = "unknown_jsonZipName.zip"
            }
        }

        CJDownloadUtil.downloadFile(fileUrl: jsonZipNetworkUrl, toDirectoryURL: toDirectoryURL, saveWithFileName: zipName, zipDecryptHandle: zipDecryptHandle, success: { zipLocalURL in
            let unzipLocalURL = zipLocalURL.deletingLastPathComponent().appendingPathComponent(upzipFileName)
            SSZipArchive.unzipFile(atPath: zipLocalURL.path, toDestination: toDirectoryURL.path, progressHandler: { (entry, ipInfo, entryNumber, total) in
                zipProgressHandler?(CGFloat(total))
            }, completionHandler: { (path, succeeded, error) in
                if succeeded == false {
                    failure("解压文件失败:\(zipLocalURL.path), \(error?.localizedDescription ?? "")")
                } else {
                    //debugPrint("解压出来的文件位于:\(path)")
                    success(unzipLocalURL)
                }
            })
        }, failure: { errorMessage in
            failure(errorMessage)
        })
    }
    
    /// 从 jsonFileURL 文件中读取 json 数据，并转为模型
    public static func parsingJsonFileLocalURL<TModel: Codable>(
        _ jsonFileLocalURL: URL,
        success: @escaping ((TModel) -> Void),
        failure: ((_ errorMessage: String) -> Void)
    ) {
        guard FileManager.default.fileExists(atPath: jsonFileLocalURL.path) else {
            failure("JSON文件不存在，请检查所拼接的路径:\(jsonFileLocalURL)")
            return
        }
        
        do {
            // 读取 JSON 文件中的数据为 Data
            let jsonData = try Data(contentsOf: jsonFileLocalURL)
            
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(TModel.self, from: jsonData)
//                let jsonString = try JSON(data: jsonData)
                success(model)
            } catch {
                let jsonString = String(data: jsonData, encoding: .utf8) ?? "unknownJRsonString"
                failure("JSON数据解析失败:\(jsonFileLocalURL) \(error.localizedDescription) \n\(jsonString)")
            }
            
        } catch {
            failure("JSON文件读取失败:\(error.localizedDescription)")
        }
    }
}
