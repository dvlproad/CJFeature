//
//  CQControlWidgetHomeView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SwiftUI

struct CQControlWidgetHomeViewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> CQControlWidgetHomeView {
        return CQControlWidgetHomeView { [self] entitySet in
            CCLogUtil.log("在首页点击了组件，正准备跳转：layoutId = \(entitySet.id)")
            
            guard #available(iOS 18.0, *) else {
                AlertUtil.showNeedIOS18Alert()
                return
            }
            
            let supportComponentIds = [
                "staticIcon_01", "staticIcon_02", "staticIcon_03", "staticIcon_04",
                "dynamicIcon_01", "dynamicIcon_fan", "dynamicIcon_supportstick", "dynamicIcon_cat",
                "quickstart_1021", "quickstart_1022", "quickstart_1023",
                "quickstart_state_1021", "quickstart_state_1022", "quickstart_state_1023",
//                    "click_1031", "click_1032", "voice_1041",
                "group_4_01", "group_4_02", "group_4_03"
            ]
            if !supportComponentIds.contains(entitySet.id) {
                AlertUtil.showUpgradeAlert()
            } else {
//                        if ["group_4_01", "group_4_02", "group_4_03"].contains(entitySet.id) {
//                            navigator.push(NavScreen.controlWidgetGroupListBySet(entitySet, navigatorModel: NavigatorModel(navigator: navigator)))
//                        } else {
//                            navigator.push(NavScreen.controlWidgetDetailBySet(entitySet))
//                        }
            }
        }
    }
    
    func updateUIView(_ uiView: CQControlWidgetHomeView, context: Context) {
        // 可选：在 SwiftUI 变化时更新 UIKit 视图
    }
}


class CQControlWidgetHomeView: UIView {
    /*
    /// 是否是 iOS18控制中心 菜单页签
    static func isIOS18ControlWidgetMenu(_ menuModel: MenuModel?) -> Bool {
        return menuModel?.name == "iOS18控制中心(非预览)"
    }
    
    // 测试用的 menu
    static func iOS18ControlWidgetMenuModel() -> MenuModel? {
        let jsonString = "{\"name\": \"iOS18控制中心(非预览)\", \"objType\" : \"ctr_component_area\"}"
        
        let ios18ControlWidgetMenuModel = MenuModel.deserialize(from: jsonString)
        return ios18ControlWidgetMenuModel
    }
    */
    
    var collectionView: CQControlWidgetCollectionView!
    
    var dataModels: [BaseControlWidgetSetModel] = []
    var onTapEntity: ((BaseControlWidgetSetModel) -> Void)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(onTapEntity: @escaping (BaseControlWidgetSetModel) -> Void) {
        self.onTapEntity = onTapEntity
        super.init(frame: .zero)
        
        setupViews()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("kNoti_Get_NewSymbols"), object: nil, queue: .main) { _ in
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .white

        self.setupCollectionView()
        
        dataModels = CQControlWidgetIds.exampleSetsFromJson()
        self.collectionView.dataModels = dataModels
    }
    
    func setupCollectionView() {
        collectionView = CQControlWidgetCollectionView(frame: .zero, onTapEntity: onTapEntity)
        self.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
