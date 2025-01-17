//
//  BaseControlWidgetToggleAction.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//

import ActivityKit
import AppIntents
import SwiftUI

@available(iOS 18.0, *)
struct BaseControlWidgetToggleAction: SetValueIntent, LiveActivityStartingIntent {
//    static var shouldOpenAppWhenRun: Bool = false
//    /// 此参数需要设为True否则不会打开主App，则应用跳转失效，且本类主Target也必须包含，否无无法触发perform
//    static var openAppWhenRun: Bool {
//        return true
////        return BaseControlWidgetToggleAction.shouldOpenAppWhenRun
//    }
    

//    static var title: LocalizedStringResource = "ControlToggleWidgetIntent"
    
    static var title: LocalizedStringResource = "Open My App"
    static var description: IntentDescription? = "Open the main application from the widget."

    ///*
    @Parameter(
        title: .init("widgets.controls.parameter.value", defaultValue: "value")
    )
    var value: Bool
    //*/
//    var value: Never?
    
    
    
    //@available(*, unavailable)
    init() {

    }
    
    @Parameter(title: "widgetId") var widgetId: String?
    @Parameter(title: "widgetSaveId") var widgetSaveId: String?
    init(widgetId: String, widgetSaveId: String) {
        self.widgetId = widgetId
        self.widgetSaveId = widgetSaveId
        
        
    }
    
    
//    @Parameter(title: "widgetModel") var widgetModel: BaseControlWidget.BaseControlWidgetModel?
//    init(widgetModel: BaseControlWidget.BaseControlWidgetModel) {
//        self.widgetModel = widgetModel
//    }
    

    @MainActor
    func startLiveActivity() {
        /*
        do {
            let _ = try Activity<ControlExtAttributes>.request(attributes: ControlExtAttributes(name: "Demo"), contentState:ControlExtAttributes.ContentState(emoji: "🤩") ,pushType:.none)
        } catch let error {
            /// 直接调用会直接抛出出异常 ActivityKit.ActivityAuthorizationError.unsupportedTarget
            /// 需要在Info.Plist里配置 Supports Live Activities  True
            debugPrint("开启灵动岛失败:\(error)")
        }
        */
    }
    
    /*
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        let appUrl = "mobilenotes://"
        if #available(iOS 18.2, *) {
            return .result(opensIntent: OpenURLIntentIOS182(openUrl: appUrl))
        } else {
            return .result(opensIntent: OpenURLIntentIOS180(openUrl: appUrl))
        }
    }
    */
    
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        // 此处实际业务处理
        // 开启灵动岛、播放声音、开启振动等
        CJLogUtil.log("您【在桌面】点击了: \(self.widgetId ?? "") \(self.widgetSaveId ?? "")")
        
        var openUrl: String?
        //let widgetId = self.widgetId
        if let widgetSaveId = self.widgetSaveId {
            var cacheEntitys = TSWidgetBundleCacheUtil.getControlWidgets()
            if var widgetModel = TSWidgetBundleCacheUtil.findControlWidgetEntity(widgetSaveId, in: cacheEntitys) {
                // 点击操作
                let oldWidgetModelOpenState = widgetModel.isOn
                BaseControlWidgetEntityHandle.handleWidgetModel(&widgetModel, caseType: .bgButtonClick, pageInfo: CQPageInfo(pageType: .inDesktop))

                // 开启灵动岛
                self.startLiveActivity()
                
                // 更新组件
                TSWidgetBundleCacheUtil.replaceEntity(widgetModel, in: &cacheEntitys, influenceScope: .dataAndWidgetUI)
                
                
                if oldWidgetModelOpenState {
                    openUrl = widgetModel.appModel?.targetUrl
                    
                }
            }
        }
        
        // 重要：打开容器App的操作
        if #available(iOS 18.1, *) {
            return .result(opensIntent: OpenURLIntentIOS181(openUrl: openUrl))
        } else {
            return .result(opensIntent: OpenURLIntentIOS180(openUrl: openUrl))
        }
    }
}
