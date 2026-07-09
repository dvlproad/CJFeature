//
//  CQControlWidgetMyCollectionViewCell.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SnapKit

import SwiftUI
import CJBaseUIKit_Swift    // 需要使用 UIView/as

import CQWidgetBundleCommon

// 使用基类为 SwiftUI View 创建 Cell
public class CQControlWidgetMyCollectionViewCell: UICollectionViewCell {
    public static var deleteControlWidgetEntityWithSaveId: ((_ saveId: String) -> Void)?  // 用来解耦 依赖了 TSWidgetBundleCacheUtil.deleteControlWidgetEntityWithSaveId(saveId)
    
    var isDeleteButton: Bool = false    // 是否按钮是作为删除按钮，flase则为安装
    var editButton: UIButton!
    var titleLabel: UILabel!
    var widgetView: CJHostingView<BaseControlWidgetViewInApp>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var deleteCompleteBlock: (()->Void)?
    func configureDeleteCompleteBlock(_ bDeleteCompleteBlock: @escaping (()->Void)) {
        deleteCompleteBlock = bDeleteCompleteBlock
    }
    
    @objc func editButtonAction() {
        if isDeleteButton {
            if let beyondViewController = self.viewController, let entity = self.entity {
                let message = entity.nameWithNumber()
                
                AlertUtil.showAlert(controller: beyondViewController, message: message, okHandle: {
                    if let saveId = entity.saveId {
                        if let deleteControlsHandler = CQControlWidgetMyCollectionViewCell.deleteControlWidgetEntityWithSaveId {
                            deleteControlsHandler(saveId)
                        } else {
                            let errorMessage = "❌Error:deleteControlWidgetEntityWithSaveId 必须设置请检查"
                            AlertUtil.showAlert(controller: beyondViewController, message: errorMessage) {
                                
                            }
                        }
                        //TSWidgetBundleCacheUtil.deleteControlWidgetEntityWithSaveId(saveId)
                        if let deleteCompleteBlock = self.deleteCompleteBlock {
                            deleteCompleteBlock()
                        }
                        // NotificationCenter.default.post(name: Notification.Name("kNoti_MyControlWidget_deleteComplete"), object: nil)
                    }
                })
            }
            
        } else {
            NotificationCenter.default.post(name: Notification.Name("kNoti_Click_install"), object: nil)
        }
    }
    
    func setupViews() {
        let editButton: UIButton = UIButton(type: .custom)
        editButton.setTitle("安装", for: .normal)
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.5, weight: .regular)
        editButton.backgroundColor = UIColor(hex: "#2E2E2E")
        editButton.layer.cornerRadius = 14
        editButton.layer.masksToBounds = true
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(28)
        }
        self.editButton = editButton
        
        
        let widgetView = CJHostingView<BaseControlWidgetViewInApp>(frame: bounds)
        self.contentView.addSubview(widgetView)
        widgetView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.widgetView = widgetView
        
        let titleLabel = UILabel()
        //titleLabel.backgroundColor = UIColor.green
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(widgetView.snp.right).offset(10)
            //make.right.equalTo(editButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        self.titleLabel = titleLabel
    }
    
    var entity: BaseControlWidgetEntity?
    func setEntity(_ entity: BaseControlWidgetEntity) {
        self.entity = entity
        self.titleLabel.text = entity.nameWithNumber()
        
        var widgetWidth: CGFloat = 0
        switch entity.widgetStyle {
        case .circle:
            widgetWidth = 59.0
        case .rectangle:
            widgetWidth = 125.0
        case .square:
            widgetWidth = 95.0
        }
        self.widgetView.snp.remakeConstraints({ make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(widgetWidth)
        })
        self.widgetView.configure(with: BaseControlWidgetViewInApp(entity: entity, pageInfo: CCPageInfo(pageType: .myWidgetPage)))
    }
    
    func updateButtonState(isDeleteButton: Bool) {
        self.isDeleteButton = isDeleteButton
        //self.editButton.isSelected = isDeleteButton
        self.editButton.setTitle(isDeleteButton ? "" : "安装", for: .normal)
        self.editButton.setImage(isDeleteButton ? UIImage(named: "photoSelect_delete") : nil, for: .normal)
        self.editButton.snp.updateConstraints { make in
            if isDeleteButton {
                make.width.equalTo(20)
                make.height.equalTo(20)
            } else {
                make.width.equalTo(57)
                make.height.equalTo(28)
            }
        }
        if isDeleteButton {
            self.editButton.layer.cornerRadius = 10
            self.editButton.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-18)
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            
        } else {
            self.editButton.layer.cornerRadius = 14
            self.editButton.snp.updateConstraints { make in
                make.right.equalToSuperview()
                make.width.equalTo(57)
                make.height.equalTo(28)
            }
        }
    }
}


import UIKit
extension UIView {
    /// 获取当前视图所在的视图控制器
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}


//struct ControlWidgetEditButton: View {
//    var body: some View {
//        CustomButton(tapComplete: {
//            if(managerStatus){
//                isAlertPresented = true
//            } else {
//                UMAnalyticsSwift.event(eventId: "My_Widget", attributes: ["MyWidget":"安装"])
//                UMAnalyticsSwift.event(eventId: "Guide", attributes: ["Guide":"引导弹窗"])
//                
//                guard (!widgetInfoModel.needVip && !baseModel.needVip && contentModel?.needVip == false && newContentModel?.needVip == false) ||
//                        VipManager.shared.isVip else {
//                    
//                    NotificationCenter.default.post(name: Notification.Name("showVipCenterView"), object: nil)
//                    return
//                }
//                if isAccessoryWidget(stypeType: widgetInfoModel.styleType) {
//                    showTutorialType = 2
//                } else {
//                    showTutorialType = 1
//                }
//            }
//        }, labelView: {
//            ZStack{
//                if(managerStatus){
//                    Image("photoSelect_delete")
//                        .resizable()
//                        .frame(width: 20,height: 20)
//                        .background(Color(hex: "#2E2E2E"))
//                        .cornerRadius(10)
//                }else{
//                    HStack {
//                        /// 有些组件不需要VIP但有包含需要VIP的素材
//                        if (baseModel.needVip || widgetInfoModel.needVip || contentModel?.needVip == true ||
//                            newContentModel?.needVip == true ||
//                            (widgetInfoModel as? SmartPanelModel)?.spiritEffectNeedVip == true ||
//                            (contentModel as? SmartPanelModel)?.spiritEffectNeedVip == true),
//                            !VipManager.shared.isVip {
//
//                            Image("needVipInstall")
//                                .resizable()
//                                .frame(width: 16,height: 14)
//                            
//                            Spacer().frame(width: 3)
//                        }
//                        Text("安装")
//                            .foregroundColor(.white)
//                            .font(.system(size: 13,weight: .regular))
//                    }
//                }
//            }
//        }, bgColor: Color(hex: "#2E2E2E"), radius: 14)
//        .frame(width: 57,height: 28)
//        
//        .alert(isPresented: $isAlertPresented) {
//            Alert(
//                title: Text("是否删除"),
//                message: Text(widgetInfoModel.title),
//                primaryButton: .destructive(Text("删除")) {
//                    UMAnalyticsSwift.event(eventId: "My_Widget", attributes: ["MyWidget":"删除"])
//                    WidgetManager.shared.deleteWidget(widgetInfoModel.identifier,
//                                                      styleType: widgetInfoModel.styleType)
//                },
//                secondaryButton: .cancel()
//            )
//        }
//        .frame(width: 50,height: 50)
//    }
//}
