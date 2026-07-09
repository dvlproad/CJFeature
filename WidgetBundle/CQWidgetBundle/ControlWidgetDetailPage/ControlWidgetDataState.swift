//
//  QuickStartInputView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//

import Foundation

// 控制中心组件数据的状态
// 是否需要下载zip。如果已经有传入完整数据了，那就不用下载
public enum ControlWidgetDataState: String {
    case unknown    // 未知
    case loading    // 加载中
    case successWithNoData  // 加载完成，但后台没有提供数据
    case successPerfect     // 真正的加载完成，有数据
    case failure    // 加载失败
    
    //0 无数据 1 无网络 2 加载中
    public func toNoDataType() -> Int {
        switch self {
        case .unknown:
            2
        case .loading:
            2
        case .successWithNoData:
            0
        case .successPerfect:
            4
        case .failure:
            1
        }
    }
}
