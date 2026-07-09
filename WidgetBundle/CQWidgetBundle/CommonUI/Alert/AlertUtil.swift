//
//  CQControlWidgetMyCollectionViewCell.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
//import SnapKit
//
//import SwiftUI
//import CJBaseUIKit_Swift    // 需要使用 UIView/as
//
//import CQWidgetBundle
//import CQWidgetBundleCommon


public class AlertUtil {
    static func showAlert(controller: UIViewController, message: String, okHandle: @escaping (() -> Void)) {
        // 创建UIAlertController，指定样式为alert
        let alert = UIAlertController(title: "是否删除", message: message, preferredStyle: .alert)
        
        // 添加一个“确定”按钮
        let okAction = UIAlertAction(title: "确定", style: .default) { action in
            okHandle()
        }
        alert.addAction(okAction)
        
        // 如果需要，还可以添加更多按钮，例如“取消”按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
            print("用户点击了取消按钮")
        }
        alert.addAction(cancelAction)
        
        // 弹出alert
        controller.present(alert, animated: true, completion: nil)
    }
    
    static public func showUpgradeAlert() {
//        let alert = SWAlertController(title: "升级提示",
//                                      message: "当前版本不支持该组件，请升级到最新版本后体验。",
//                                      confirmTitle: "前往升级",
//                                      confirmHandler: {action in
//            UMAnalyticsSwift.event(eventId: "Home", attributes: ["home":"点击升级"])
//            openAppPreview(url: appstoreUrl)
//        },
//                                      cancelTitle: "取消",
//                                      cancelHandler: { action in
//        })
//        alert.show()
//        UMAnalyticsSwift.event(eventId: "Home", attributes: ["home":"升级弹"])
    }
    
    static public func showNeedIOS18Alert() { //TODO: qian
//        let alert = SWAlertController(title: "系统版本过低", message: "你的设备运行iOS系统版本过低，不支持此组件，请升级系统", confirmTitle: "去升级", confirmHandler: {action in
//            //UMAnalyticsSwift.event(eventId: "Home", attributes: ["home":"点击升级"])
//            openAppSettings()
//        }, cancelTitle: "好的", cancelHandler: { action in
//
//        })
//        alert.show()
        //UMAnalyticsSwift.event(eventId: "Home", attributes: ["home":"升级弹"])
    }
}
