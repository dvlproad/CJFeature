//
//  CQControlWidgetCollectionViewCell.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SnapKit

// 使用基类为 SwiftUI View 创建 Cell
class CQControlWidgetCollectionViewCell: UICollectionViewCell {
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
            make.height.equalTo(20)
        }
        self.titleLabel = titleLabel
        
        let widgetView = CJHostingView<BaseControlWidgetViewInApp>(frame: bounds)
        self.contentView.addSubview(widgetView)
        widgetView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        self.widgetView = widgetView
    }
    
    func setEntity(_ entity: BaseControlWidgetEntity) {
        self.titleLabel.text = entity.name
        self.widgetView.configure(with: BaseControlWidgetViewInApp(entity: entity))
    }
}
