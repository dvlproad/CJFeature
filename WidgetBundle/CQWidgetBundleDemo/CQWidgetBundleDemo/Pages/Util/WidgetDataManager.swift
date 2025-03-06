//
//  WidgetDataManager.swift
//  WidgetIsland
//
//  Created by admin on 2024/7/12.
//

import Foundation
import Foundation


class WidgetDataManager {
    let sharedContainerURL: URL?
    
    init() {
        sharedContainerURL = createWidgetsDataFolder()
    }
    /// 单例
    static let shared: WidgetDataManager = WidgetDataManager()
    
    func wirteData(_ dataString: String,fileName:String,completion: @escaping (Bool) -> Void) {
        guard let sharedContainerURL = sharedContainerURL else {
            print("Error: Shared container URL is nil")
            return
        }

        let fileURL = sharedContainerURL.appendingPathComponent("\(fileName).json")
        
        do {
            let data = dataString.data(using: .utf8)
            try data?.write(to: fileURL, options: .atomic)
            completion(true)
            print("保存成功==\(dataString)")

        } catch {
            print("Error saving model: \(error)")
            completion(false)
        }
    }
    
    //获取组件
    func loadData(fileName:String) -> String? {
           guard let sharedContainerURL = sharedContainerURL else {
               print("Error: Shared container URL is nil")
               return nil
           }

           let fileURL = sharedContainerURL.appendingPathComponent("\(fileName).json")
           do {
               let data = try Data(contentsOf: fileURL)
               let jsonObject =  data.string
               
               return jsonObject
           } catch {
               print("Error loading model: \(error)")
               return nil
           }
    }
    
    //删除组件
    func removeData(fileName:String) -> Bool{
           guard let sharedContainerURL = sharedContainerURL else {
               print("Error: Shared container URL is nil")
               return false
           }
        let fileURL = sharedContainerURL.appendingPathComponent("\(fileName).json")
            let fileManger = FileManager.default
           do {
               try fileManger.removeItem(at: fileURL)
               print("删除成功")
               return true

           } catch {
               print("Error 删除 model: \(error)")
               return false
           }
       }
    
    func checkDataExists(fileName: String) -> Bool {
        guard let sharedContainerURL = sharedContainerURL else {
            print("Error: Shared container URL is nil")
            return false
        }
        
        let fileURL = sharedContainerURL.appendingPathComponent("\(fileName).json")
        let fileManager = FileManager.default
        
        let fileExists = fileManager.fileExists(atPath: fileURL.path)
        if fileExists {
            print("File \(fileName).json exists at path: \(fileURL.path)")
        } else {
            print("File \(fileName).json does not exist")
        }
        
        return fileExists
    }
    //更换环境删除所有缓存
    func removeAllData(){
        let defaults = UserDefaults.standard
           let dictionary = defaults.dictionaryRepresentation()
        let noRemoveKey = ["showWallpaperGuide",
                           "showUserAgreementAlert",
                           "kDefaultKey_useMoreThanOneMinTimes",
                           "activateDevice",
                           "showGuideView",
                           "firstTutorials",
                           "firstAccessoryTutorials",
                           "argumentIos",
                           "kDefaultKey_showed_review_alert",
                           "Moya_baseURL"]
           dictionary.keys.forEach { key in
               if noRemoveKey.contains(key) == false{
                   defaults.removeObject(forKey: key)
               }
           }
           // 同步更改
           defaults.synchronize()
        deleteWidgetsDataFolder()
        
    }
    
}

func createWidgetsDataFolder() -> URL? {
    // 获取应用的Documents目录路径
    let documentsDirectory: URL
    do {
        documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
        print("Error retrieving documents directory: \(error.localizedDescription)")
        return nil
    }

    // 拼接文件夹路径
    let widgetsDataDirectory = documentsDirectory.appendingPathComponent("widgetsData")

    // 检查文件夹是否存在
    var isDirectory: ObjCBool = false
    if FileManager.default.fileExists(atPath: widgetsDataDirectory.path, isDirectory: &isDirectory) {
        if isDirectory.boolValue {
            // 如果文件夹已存在，直接返回URL
            print("widgetsData folder already exists at path: \(widgetsDataDirectory.path)")
            return widgetsDataDirectory
        } else {
            // 存在同名文件但不是文件夹
            print("A file with the same name as the desired directory already exists: \(widgetsDataDirectory.path)")
            return nil
        }
    }

    // 文件夹不存在，创建文件夹
    do {
        try FileManager.default.createDirectory(at: widgetsDataDirectory, withIntermediateDirectories: true, attributes: nil)
        print("widgetsData folder created at path: \(widgetsDataDirectory.path)")
        return widgetsDataDirectory
    } catch {
        // 详细打印错误信息，包括错误码
        print("Error creating widgetsData folder: \(error.localizedDescription) (code: \((error as NSError).code))")
        
        // 检查是否有权限问题
        if (error as NSError).code == NSFileWriteNoPermissionError {
            print("Permission error: unable to create directory at path: \(widgetsDataDirectory.path)")
        }
        
        return nil
    }
}



func deleteWidgetsDataFolder() {
    do {
        // 获取应用的Documents目录路径
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        // 拼接文件夹路径
        let widgetsDataDirectory = documentsDirectory.appendingPathComponent("widgetsData")
        
        // 检查文件夹是否存在
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: widgetsDataDirectory.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                // 文件夹存在，删除文件夹及其内容
                try FileManager.default.removeItem(at: widgetsDataDirectory)
                print("widgetsData folder deleted at path: \(widgetsDataDirectory.path)")
            } else {
                print("Path exists but is not a directory")
            }
        } else {
            print("widgetsData folder does not exist at path: \(widgetsDataDirectory.path)")
        }
    } catch {
        print("Error deleting widgetsData folder: \(error.localizedDescription)")
    }
}
