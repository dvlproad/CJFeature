//
//  CCRequestUtil.swift
//  WidgetIsland
//
//  Created by qian on 2025/2/17.
//

import Foundation
import Combine
//import Moya

class CCRequestUtil: NSObject {
    static func requestControlWidgetData<T: Codable>(
        _ target: TargetType,
        needShowFailAlert: Bool = true,
        successCallback: @escaping ((T, ResponseModel) -> Void),
        failureCallback: @escaping ((ResponseModel) -> Void)
    ) {
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { (responseModel) in
            let jsonString = responseModel.dataString
            
            // 将 JSON 字符串转换为 Data
            if let jsonData = jsonString.data(using: .utf8) {
                let decoder = JSONDecoder()
                
                do {
                    let model = try decoder.decode(T.self, from: jsonData)
                    successCallback(model, responseModel)
                } catch {
                    print("解析失败: \(error)")
                    //    print("发生错误：\(code)--\(message)")
                    let model = ResponseModel()
                    model.code = responseModel.code
                    model.message = "解析失败"
                    failureCallback(model)
                }
            }
            
        }, failureCallback: { (responseModel) in
//            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
            failureCallback(responseModel)
        })
    }
    
    static func cacheRequestControlWidgetDatas<T: Codable>(
        _ target: TargetType,
        needShowFailAlert: Bool = true,
        successCallback: @escaping (([T], ResponseModel) -> Void),
        failureCallback: @escaping ((ResponseModel) -> Void)
    ) {
        let baseUrl = target.baseURL.absoluteString
        let path = target.path
        let url = baseUrl + path
        
        var urlTag: String = path.replacingOccurrences(of: "/", with: "_")
        let urlKey = "\(url.md5())_\(urlTag)"
//        let valueString: String? = UserDefaults.standard.value(forKey: urlKey) as? String
//        if let valueString = valueString, valueString.count > 0 {
//            let values: [T]? = []
//            successCallback(values, ResponseModel());
//        }
        
        var isGetCacheSuccess: Bool = false
        if let jsonString = WidgetDataManager.shared.loadData(fileName: urlKey) {
            // 将 JSON 字符串转换为 Data
            if let jsonData = jsonString.data(using: .utf8) {
                let decoder = JSONDecoder()
                
                do {
                    let responseModel = ResponseModel()
                    responseModel.code = 200
                    responseModel.message = "获取缓存数据成功，执行成功回调"
                    
                    let models = try decoder.decode([T].self, from: jsonData)
                    isGetCacheSuccess = true
                    successCallback(models, responseModel)
                } catch {
                    print("缓存数据解析失败，不执行失败回调: \(error)")
                }
            }
        }
        
        requestControlWidgetDatas(target, needShowFailAlert: needShowFailAlert, successCallback: { (models: [T], responseModel) in
            successCallback(models, responseModel)
            
            let jsonString = responseModel.dataString
            WidgetDataManager.shared.wirteData(jsonString, fileName: urlKey) { success in
                print("success==\(success)")
            }
            
        }, failureCallback: { (responseModel) in
            if !isGetCacheSuccess { // 从未成功获取到数据（包含从缓存中获取），则执行失败
                failureCallback(responseModel)
            }
        })
    }
    
    
    static func requestControlWidgetDatas<T: Codable>(
        _ target: TargetType,
        needShowFailAlert: Bool = true,
        successCallback: @escaping (([T], ResponseModel) -> Void),
        failureCallback: @escaping ((ResponseModel) -> Void)
    ) {
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { (responseModel) in
            let jsonString = responseModel.dataString
            
            // 将 JSON 字符串转换为 Data
            if let jsonData = jsonString.data(using: .utf8) {
                let decoder = JSONDecoder()
                
                do {
                    let models = try decoder.decode([T].self, from: jsonData)
                    successCallback(models, responseModel)
                } catch {
                    print("解析失败: \(error)")
                    //    print("发生错误：\(code)--\(message)")
                    let model = ResponseModel()
                    model.code = responseModel.code
                    model.message = "解析失败"
                    
                    failureCallback(model)
                }
            }
        }, failureCallback: { (responseModel) in
//            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
            failureCallback(responseModel)
        })
        
//        NetWorkRequest(requestTarget, modelType: [ControlWidgetPreviewModel].self, successCallback: { (prviewModels, responseModel) in
////            let list = dynamicallyOrganizeWidgets(widgets: prviewModels)
////            if areaCode != "recomment-ios"{
////                WidgetDataManager.shared.wirteData(responseModel.dataString, fileName: areaCode) { success in
////                    print("success==\(success)")
////                }
////            }
////            success?(prviewModels, areaModel,index)
//        }, failureCallback: { (responseModel) in
//            print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
////            fail?()
//        })
    }
}


enum API{
    case menu //菜单列表
    case eventBatchEvent(list:[[String: Any]])///桌面点击事件上报
    
//    控制组件专区
//      GET /app/ctr-component-area/{code}
//      接口地址：https://app.apifox.com/link/project/3874100/apis/api-260591848
    case ctrComponentArea(code: String)
    
//    控制中心图标数据
//      GET /app/ctr/icon/all
//      接口地址：https://app.apifox.com/link/project/3874100/apis/api-260644835
    case ctrIconAll
    
//    文字素材数据
//      GET /app/text/asset/all
//      接口地址：https://app.apifox.com/link/project/3874100/apis/api-260647131
    case textAssetAll
}

extension API:TargetType {
    //枚举值分别是dev和prd
    var headers: [String : String]? {
        return ["Content-Type":"application/json",
//                "charset":"UTF",
                "client_version_name":Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "未知版本",
                "client_package_name":"cn.widgetisland.theme",
                "client_channel_name":"1.0"
        ]
    }
    
    var baseURL: URL {
        switch self {
        default:
            return URL.init(string:("Moya_baseURL"))!
        }
    }
    
    var path: String {
        switch self {
        case .menu:
            return "/menu"
        case .eventBatchEvent:
            return "/event/batch-event"
        case .ctrComponentArea(code: let code):
            return "/ctr-component-area/\(code)"
        case .ctrIconAll:
            return "/ctr/icon/all"
        case .textAssetAll:
            return "/text/asset/all"
        }
    }
    
    
    

    //    这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

//    /// The HTTP method used in the request.
//    var method: Moya.Method { get }
//
//    /// Provides stub data for use in testing. Default is `Data()`.
//    var sampleData: Data { get }
//
//    /// The type of HTTP task to be performed.
//    var task: Task { get }
//
//    /// The type of validation to perform on the request. Default is `.none`.
//    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

class ResponseModel {
    var code: Int = -999
    var message: String = ""
    // 这里的data用String类型 保存response.data
    var dataString: String = ""
    /// 分页的游标 根据具体的业务选择是否添加这个属性
    var cursor: String = ""
}

// 网络请求的回调 包括：网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestCallback = ((ResponseModel) -> Void)
/// 网络错误的回调
typealias errorCallback = (() -> Void)


/// 网络请求的基础方法
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true, successCallback:@escaping RequestCallback, failureCallback: RequestCallback? = nil) -> Void {
    //当您声明一个接收闭包作为参数的函数，并且这个闭包需要在函数返回后执行时，就需要使用 @escaping
    
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        let sectionDataModels: [TextLinkMenuSectionModel] = TextLinkMenuSectionModel.textSectionExamples()
//        self.setupDataSource(sectionDataModels: sectionDataModels)
//    }
    
}

/// 错误处理
/// - Parameters:
///   - code: code码
///   - message: 错误消息
///   - needShowFailAlert: 是否显示网络请求失败的弹框
///   - failure: 网络请求失败的回调
private func errorHandler(code: Int, message: String, needShowFailAlert: Bool, failure: RequestCallback?) {
//    print("发生错误：\(code)--\(message)")
    let model = ResponseModel()
    model.code = code
    model.message = message
    if needShowFailAlert {
        // 弹框
//        print("弹出错误信息弹框\(message)")
    }
    failure?(model)
}
