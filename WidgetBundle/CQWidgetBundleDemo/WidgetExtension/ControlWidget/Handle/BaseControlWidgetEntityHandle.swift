//
//  BaseControlWidgetEntityHandle.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//

import Foundation

/// 更新UI的起因
enum CQUpdateUICauseType {
    case onAppear       // 该视图显示时候
    case bgButtonClick  // 背景按钮的点击
}

struct BaseControlWidgetEntityHandle {    // MARK: UpdateUI
    static func handleWidgetModel(_ model: inout BaseControlWidgetEntity, caseType: CQUpdateUICauseType, pageInfo: CQPageInfo?) {
        CJLogUtil.log("温馨提示：您在【\(pageInfo?.pageType.rawValue ?? "")】点击了《\(model.title)》其id=\(model.id)")
        if caseType == .bgButtonClick {
            model.clickModel.count += 1  // 点击次数
            
            // 如果有使用到开启LiveActivity 这个数据管理类的数据需要做持久化处理，否则value会一直变化,出现不可预知的异常
            let widgetId = model.id
            if widgetId == CQControlWidgetIds.meritsWoodenFishControlWidgetID {
                var imageScaeModel = model.animateModel
                imageScaeModel.isAnimating = true
                model.title = "x\(model.clickModel.count)"
                
            } else if widgetId == CQControlWidgetIds.diceControlWidgetID {
                //newWidgetModel.isOn.toggle()
                model.imageName = CJTestUtil.generateRandomImageName()
                
            } else {
//                model.isOn.toggle()
                var imageScaeModel = model.animateModel
                imageScaeModel.isAnimating = true
                model.animateModel = imageScaeModel
            }
        }
        
        
        let pageType = getCurrentPageType(pageInfo)
        if caseType == .bgButtonClick {
            if pageType == .inDesktop {
                //WidgetCenter.shared.reloadAllTimelines()
                //WidgetCenter.shared.reloadTimelines(ofKind: model.beyondFamily.kind)
            }
            
        }
    }
    
    fileprivate static func playAudio(_ audioName: String, caseType: CQUpdateUICauseType, pageInfo: CQPageInfo?) {
        let pageType = getCurrentPageType(pageInfo)
        if  caseType == .bgButtonClick {
            if pageType == .widgetDetailPage || pageType == .inDesktop {
                //SoundPlayer.shared.play(audioName)
            }
        }
    }
    
    static func getCurrentPageType(_ pageInfo: CQPageInfo?) -> CQPageType {
        if let pageInfo = pageInfo {
            return pageInfo.pageType
        }
        return .unknown
    }
}
