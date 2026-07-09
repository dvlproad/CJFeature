//
//  TSControlWidgetDetailPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI


public class SWToast: NSObject {
    
    public static let shared = SWToast()
    
    
    public static func showText(_ view: UIView? = nil, message: String?,
                                duration: TimeInterval = 2.0,
                                animated: Bool = true,
                                mask: Bool = false) -> Void {
        
    }
    
    public static func hideAll() {
        
    }
    

}

public struct TSToastUtil {
    static public func showTodo(_ message: String) {
        SWToast.showText(message: "待开发:\(message)")
    }
    
    static public func showMessage(_ message: String) {
        SWToast.showText(message: "\(message)")
    }
}
