//
//  CQControlWidgetHomePreviewViewController.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SDWebImageWebPCoder

import SwiftUI
import CQWidgetBundleCommon // 需要使用 ControlWidgetType
import CQWidgetBundle   // 需要使用 HomePageNoDataView

public struct CQControlWidgetHomePreviewViewWrapper: UIViewRepresentable {
    public func makeUIView(context: Context) -> CQControlWidgetHomePreviewView {
        return CQControlWidgetHomePreviewView { [self] previewModel in
            CCLogUtil.log("在首页点击了组件，正准备跳转：layoutId = \(previewModel.id)")
            //CCControlWidgetEventUtil.clickWidgetId(previewModel.id)
            
            guard #available(iOS 18.0, *) else {
                AlertUtil.showNeedIOS18Alert()
                return
            }
            
            if previewModel.type == .set {
//                        previewModel.navigator = navigator
//                        navigator.push(NavScreen.controlWidgetGroupByPreviewModel(previewModel))
            } else {
//                    let supportComponentIds = [
//                        "2",
//                        "1", "3", "4", "5",
//                        "7", "8", "9", "10",
//                        "11", "12", "13", "14",
//    //                    "6",
//                    ]
                let supportComponentCategorys: [ControlWidgetType] = [
                    .toggle_icon,
                    .open_app,
                ]
                if !supportComponentCategorys.contains(previewModel.componentCategory) {
                    AlertUtil.showUpgradeAlert()
                } else {
//                            previewModel.navigator = navigator
//                            navigator.push(NavScreen.controlWidgetDetailByPreviewModel(previewModel))
                }
            }
        }
    }
    
    public func updateUIView(_ uiView: CQControlWidgetHomePreviewView, context: Context) {
        // 可选：在 SwiftUI 变化时更新 UIKit 视图
    }
}


class MenuModel: NSObject {
    var objId:  String?
    var name: String?
    var objType: String?
    var objValue: String?
    var type: Int?
    var id: Int?
    var icon:String?
    var iconWidth:Float?
    var iconHeight:Float?
    var iconVisibleFlag: Bool = false
}



public class CQControlWidgetHomePreviewView: UIView {
    /*
    /// 是否是 iOS18控制中心 菜单页签
    static func isIOS18ControlWidgetMenu(_ menuModel: MenuModel?) -> Bool {
        return menuModel?.objType == "ctr_component_area"
    }
    
    // 测试用的 menu
    static func iOS18ControlWidgetMenuModel() -> MenuModel? {
        let jsonString = "{\"name\": \"iOS18控制中心\", \"objType\" : \"ctr_component_area\"}"
        
        let ios18ControlWidgetMenuModel = MenuModel.deserialize(from: jsonString)
        return ios18ControlWidgetMenuModel
    }
    */
    
    static var menuModel: MenuModel?
    
    var collectionView: ControlWidgetHomePreviewCollectionView!
    var errorView: CJHostingView<HomePageNoDataView>!
    
    var dataModels: [ControlWidgetPreviewModel] = []
    var onTapEntity: ((ControlWidgetPreviewModel) -> Void)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(onTapEntity: @escaping (ControlWidgetPreviewModel) -> Void) {
        self.dataState = .loading
        self.onTapEntity = onTapEntity
        super.init(frame: .zero)
        
        // 注册 WebP 解码器
        let webPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webPCoder)
        
        setupViews()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("kNoti_Get_NewSymbols"), object: nil, queue: .main) { _ in
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataState: ControlWidgetDataState //控制中心组件数据的状态
    func setupViews() {
        self.backgroundColor = .white

        self.setupCollectionView()
        
        self.updateState(.loading)
        self.requestPreviewData()
    }

    
    func requestPreviewData() {
//        dataModels = CQControlWidgetIds.exampleSetsFromJson()
//        self.collectionView.dataModels = dataModels
        let code = CQControlWidgetHomePreviewView.menuModel?.objValue ?? ""
        CCRequestUtil.cacheRequestControlWidgetDatas(
            API.ctrComponentArea(code: code),
            successCallback: { (models: [ControlWidgetPreviewModel], responseModel) in
                self.dataModels = models
                self.updateState(models.count > 0 ? .successPerfect : .successWithNoData)
                
                self.collectionView.dataModels = models
                self.collectionView.reloadData()
            }, failureCallback: { (responseModel) in
                print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
                self.updateState(.failure)
            }
        )
    }
    
    func updateState(_ dataState: ControlWidgetDataState) {
        self.dataState = dataState
        
        if(dataState != .successPerfect) {
            self.errorView.isHidden = false
            self.collectionView.isHidden = true
            
            let noDataType = dataState.toNoDataType()
            let errorView = HomePageNoDataView(noDataType: .constant(noDataType)) {
                self.updateState(.loading)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.requestPreviewData()
                }
            }
            self.errorView.configure(with: errorView)
            
        } else {
            self.errorView.isHidden = true
            self.collectionView.isHidden = false
        }
    }
    
    func setupCollectionView() {
        collectionView = ControlWidgetHomePreviewCollectionView(frame: .zero, onTapEntity: onTapEntity)
        self.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
        errorView = CJHostingView<HomePageNoDataView>(frame: bounds)
        self.addSubview(errorView)
        self.errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.errorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.errorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.errorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.errorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        /*
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("请求数据", for: .normal)
        button.addTarget(self, action: #selector(onTapBack), for: .touchUpInside)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        */
    }
    
    @objc func onTapBack() {
        self.requestPreviewData()
    }
}
