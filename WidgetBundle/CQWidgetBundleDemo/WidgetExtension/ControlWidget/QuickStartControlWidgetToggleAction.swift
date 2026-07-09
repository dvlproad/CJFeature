//
//  QuickStartControlWidgetToggleAction.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//

import ActivityKit
import AppIntents
import SwiftUI
import CQWidgetBundleCommon // 需要 PageInfo

@available(iOS 18.0, *)
struct QuickStartControlWidgetToggleAction: SetValueIntent, AudioPlaybackIntent, LiveActivityStartingIntent {
//    static var shouldOpenAppWhenRun: Bool = false
//    /// 此参数需要设为True否则不会打开主App，则应用跳转失效，且本类主Target也必须包含，否无无法触发perform
//    static var openAppWhenRun: Bool {
//        return true
////        return BaseControlWidgetToggleAction.shouldOpenAppWhenRun
//    }
    

//    static var title: LocalizedStringResource = "ControlToggleWidgetIntent"
    
    static var title: LocalizedStringResource = "Open My App"
    static var description: IntentDescription? = "Open the main application from the widget."
    
    static var openAppWhenRun: Bool = true    // 不设置此行值为true，会导致点击的时候有颜色变化再变回去
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
    @Parameter(title: "desktopWidgetControlTypeString") var desktopWidgetControlTypeString: String
    init(widgetId: String, widgetSaveId: String, desktopWidgetControlTypeString: String) {
        self.widgetId = widgetId
        self.widgetSaveId = widgetSaveId
        self.desktopWidgetControlTypeString = desktopWidgetControlTypeString
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
        if #available(iOS 18.1, *) {
            return .result(opensIntent: OpenURLIntentIOS182(openUrl: appUrl))
        } else {
            return .result(opensIntent: OpenURLIntentIOS180(openUrl: appUrl))
        }
    }
    */
    
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
    // 注意：perform() 中操作的 cacheEntitys 必须和 func suggestedEntities() async throws 中的一直，不能一个是 getControlWidgets()，一个是 getCacheControlWidgets()，如果不一致则会出现点击无效
        // 此处实际业务处理
        // 开启灵动岛、播放声音、开启振动等
        CCLogUtil.log("您【在桌面】点击了: \(self.widgetId ?? "") \(self.widgetSaveId ?? "")")
        
        var openUrl: String?
        //let widgetId = self.widgetId
        if let widgetSaveId = self.widgetSaveId {
            var cacheEntitys = TSWidgetBundleCacheUtil.getCacheControlWidgets(.all)
            if var widgetModel = TSWidgetBundleCacheUtil.findControlWidgetEntity(widgetSaveId, in: cacheEntitys) {
                // 点击操作
                let oldWidgetModelOpenState = widgetModel.isOn
                BaseControlWidgetEntityHandle.handleWidgetModel(&widgetModel, caseType: .bgButtonClick, pageInfo: CCPageInfo(pageType: .inDesktop))

                // 开启灵动岛
                self.startLiveActivity()
                
                // 更新组件
                TSWidgetBundleCacheUtil.replaceEntity(widgetModel, in: &cacheEntitys, influenceScope: .dataAndReloadControls)
                
                
                if oldWidgetModelOpenState {
                    openUrl = widgetModel.onModel.getOpenUrl()
                    
                }
            }
        }
        
        // 重要：打开容器App的操作
        if #available(iOS 18.1, *) {
            return .result(opensIntent: OpenURLIntentIOS181(openUrl: openUrl))
        } else {
//            if openUrl == nil {
//                return .result(opensIntent: OpenURLIntent())
//            }
            return .result(opensIntent: OpenURLIntentIOS180(openUrl: openUrl))
        }
    }
}
