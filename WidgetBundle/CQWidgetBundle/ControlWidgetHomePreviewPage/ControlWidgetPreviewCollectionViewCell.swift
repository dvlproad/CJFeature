//
//  ControlWidgetEntityPreviewCollectionViewCell.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/14.
//

import UIKit
import SnapKit
import SDWebImage

class ControlWidgetEntityPreviewCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var preImageView: SDAnimatedImageView! // 预览图（整个结构使用预览图展示）
    
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
        
        let preImageView = SDAnimatedImageView()
        preImageView.layer.masksToBounds = true
        //preImageView.backgroundColor = .blue
        preImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(preImageView)
        preImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        self.preImageView = preImageView
    }
    
    func setEntity(_ previewModel: ControlWidgetPreviewModel) {
        self.preImageView.layer.borderWidth = 0.5
        self.preImageView.layer.borderColor = UIColor(hex: "#F0F0F0").cgColor
        if previewModel.style == .circle {
            self.preImageView.layer.cornerRadius = CGRectGetWidth(self.frame)/2.0
        } else {
            self.preImageView.layer.cornerRadius = 22.5
        }
        
        self.titleLabel.text = previewModel.name
        
        let previewItemModel: ControlWidgetPreviewItemModel? = previewModel.entitys.first
        let previewImageUrl = previewItemModel?.imageUrl ?? ""
        self.preImageView.sd_setImage(with: URL(string: previewImageUrl))
    }
}
