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

    static var title: LocalizedStringResource = "ControlToggleWidgetIntent"

    @Parameter(
        title: .init("widgets.controls.parameter.value", defaultValue: "value")
    )
    var value: Bool
    
    
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

    @MainActor
    func perform() async throws -> some IntentResult {
        // 此处实际业务处理
        // 开启灵动岛、播放声音、开启振动等
        CJLogUtil.log("您【在桌面】点击了: \(self.widgetId ?? "") \(self.widgetSaveId ?? "")")
//        return .result()
        
        //guard let widgetId = self.widgetId else { return .result() }
        guard let widgetSaveId = self.widgetSaveId else { return .result() }
        
        var cacheEntitys = TSWidgetBundleCacheUtil.getControlWidgets()
        guard var widgetModel = TSWidgetBundleCacheUtil.findControlWidgetEntity(widgetSaveId, in: cacheEntitys) else { return .result() }
        
        // 点击操作
        BaseControlWidgetEntityHandle.handleWidgetModel(&widgetModel, caseType: .bgButtonClick, pageInfo: CQPageInfo(pageType: .inDesktop))

        // 开启灵动岛
        self.startLiveActivity()
        
        // 更新组件
        TSWidgetBundleCacheUtil.replaceEntity(widgetModel, in: &cacheEntitys, influenceScope: .dataAndWidgetUI)

        return .result()
    }
}
