//
//  CQControlWidgetEntityCollectionViewCell.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SnapKit
import CQWidgetBundle // 需要使用 CJHostingView
import CQWidgetBundleCommon

class CQControlWidgetEntityCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var widgetView: CJHostingView<BaseControlWidgetViewInApp>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let titleLabel = UILabel()
        //titleLabel.backgroundColor = UIColor.green
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(12)
        }
        self.titleLabel = titleLabel
        
        let widgetView = CJHostingView<BaseControlWidgetViewInApp>(frame: bounds)
        self.contentView.addSubview(widgetView)
        widgetView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        self.widgetView = widgetView
    }
    
    func setEntity(_ entity: BaseControlWidgetEntity) {
        self.titleLabel.text = entity.name
        /*
        self.widgetView.layer.borderWidth = 0.5
        self.widgetView.layer.borderColor = UIColor(hex: "#F0F0F0").cgColor
        if entity.widgetStyle == .circle {
            self.widgetView.layer.cornerRadius = CGRectGetWidth(self.frame)/2.0
        } else {
            self.widgetView.layer.cornerRadius = 22.5
        }
        */
        self.widgetView.configure(with: BaseControlWidgetViewInApp(entity: entity, pageInfo: CCPageInfo(pageType: .homePage)))
    }
}
