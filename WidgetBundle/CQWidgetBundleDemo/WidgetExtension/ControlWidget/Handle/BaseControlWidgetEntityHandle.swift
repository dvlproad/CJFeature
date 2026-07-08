//
//  BaseControlWidgetEntityHandle.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//

import Foundation
import UIKit
import CQWidgetBundleCommon

/// 更新UI的起因
enum CQUpdateUICauseType {
    case onAppear       // 该视图显示时候
    case bgButtonClick  // 背景按钮的点击
}

@available(iOS 16.0, *)
struct BaseControlWidgetEntityHandle {    // MARK: UpdateUI
    static func handleWidgetModel(_ model: inout BaseControlWidgetEntity, caseType: CQUpdateUICauseType, pageInfo: CCPageInfo?) {
        CCLogUtil.log("温馨提示：您在【\(pageInfo?.pageType.rawValue ?? "")】点击了《\(model.name)》其id=\(model.id)")
        
//        CCControlWidgetEventUtil.clickWidgetId(model.widgetId)
        
        if caseType == .bgButtonClick {
            let oldWidgetModelOpenState = model.isOn
            
            model.clickModel?.count += 1  // 点击次数
            
            // 如果有使用到开启LiveActivity 这个数据管理类的数据需要做持久化处理，否则value会一直变化,出现不可预知的异常
            let widgetType = model.widgetType
            if widgetType == .toggle_icon {
                model.isOn.toggle()
                
            } else if widgetType == .open_app || widgetType == .open_shortcut {
                // 快捷启动应用
            }
//            } else if widgetType == .woodenFish {
//                //var imageScaeModel = model.animateModel
//                //imageScaeModel.isAnimating = true
//                model.onModel.title = "x\(model.clickModel?.count)"
//                
//            } else if widgetType == .dice {  // 骰子🎲
//                model.isOn = true
//                model.onModel.imageModel.imageName = CJTestUtil.generateRandomImageName()
//            }
            
            /*
            if oldWidgetModelOpenState {
                let audioName = "鞭炮"
                SoundPlayer.shared.play(audioName)
            }
            */
        }
        

#if Main_TARGET
//        if let appModel = model.appModel {
//            let appUrl = appModel.targetUrl
//            if let url = URL(string: appUrl) {
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    print("无法打开【 \(appUrl) 】应用，可能未安装或损坏。请尝试重启设备或重新安装备忘录应用。")
//                }
//            }
//        }
#endif
        
        // 0.5 秒后发出通知
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            NotificationCenter.default.post(name: Notification.Name("openUrlViaWidget"), object: ["url": appUrl])
        }
        
        let pageType = getCurrentPageType(pageInfo)
        if caseType == .bgButtonClick {
            if pageType == .inDesktop {
                //WidgetCenter.shared.reloadAllTimelines()
                //WidgetCenter.shared.reloadTimelines(ofKind: model.beyondFamily.kind)
            }
            
        }
    }
    
    fileprivate static func playAudio(_ audioName: String, caseType: CQUpdateUICauseType, pageInfo: CCPageInfo?) {
        let pageType = getCurrentPageType(pageInfo)
        if  caseType == .bgButtonClick {
            if pageType == .controlWidgetDetailPage || pageType == .inDesktop {
                //SoundPlayer.shared.play(audioName)
            }
        }
    }
    
    static func getCurrentPageType(_ pageInfo: CCPageInfo?) -> CCPageType {
        if let pageInfo = pageInfo {
            return pageInfo.pageType
        }
        return .unknown
    }
}
