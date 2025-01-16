//
//  AudioSystemIntent.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/16.
//

import WidgetKit
import AppIntents

@available(iOS 16, *)
struct AudioSystemIntent: AudioPlaybackIntent {
    
    static var title: LocalizedStringResource = "DiscAlbum Task"
    static var description: IntentDescription = IntentDescription("DiscAlbum Task")
    
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "widgetId")
    var widgetId: String?
    
    init() { }
    init(widgetId: String) {
        self.widgetId = widgetId
    }
    
    /*
    var onTap: @Sendable (CCOnlyImageModel) -> Void
    init() {
        self.onTap = { _ in
            debugPrint("温馨提示init：您在【在桌面】点击了背景")
        }
    }
    init(widgetId: String, onTap: @escaping @Sendable (CCOnlyImageModel) -> Void) {
        self.onTap = onTap
        self.widgetId = widgetId
    }
    */
    func perform() async throws -> some IntentResult {
        CJLogUtil.log("您【在桌面】点击了: \(self.widgetId ?? "")")
//        
//        guard let widgetId = widgetId else { return .result() }
//        
//        guard let widget = WidgetManager.shared.findWidget(widgetId), let widgetModel = CCOnlyImageModel.deserialize(from: widget.content.toDictionary()) else { return .result() }
//        
//        debugPrint("温馨提示perform1：您在【在桌面】点击了《\(widgetModel.title ?? "")》其layoutId=\(widgetModel.layoutId ?? "")")
////        onTap(widgetModel)
//        CCOnlyImageViewUtil.updateUI(model: widgetModel, caseType: .bgButtonClick, pageInfo: CCPageInfo(pageType: .inDesktop))
//        debugPrint("温馨提示perform2：您在【在桌面】点击了《\(widgetModel.title ?? "")》其layoutId=\(widgetModel.layoutId ?? "")")
//        
//        widget.content = widgetModel.toJSONString() ?? ""
//        WidgetManager.shared.saveWidget(widget, needRefresh: false)
//        WidgetManager.shared.eventReportedApiNet(outId: "\(widgetModel.id ?? 0)", eventCode: "desktop_click")
        return .result()
    }
}
