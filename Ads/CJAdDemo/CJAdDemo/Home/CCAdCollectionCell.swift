//
//  CCAdCollectionCell.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/6.
//

import Foundation
import UIKit
import SnapKit

class CCAdCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
    }
    
    func showExpressView(_ expressView: UIView?, adviewTopMargin: CGFloat, adviewBottomMargin: CGFloat) {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let container: UIView = UIView()
        container.layer.cornerRadius = 13
        container.layer.masksToBounds = true
        self.contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(adviewTopMargin)
            make.bottom.equalTo(self.contentView).offset(-adviewBottomMargin)
        }
        
        if let expressView = expressView {
            //expressView.backgroundColor = .white
            container.addSubview(expressView)
            expressView.snp.makeConstraints { make in
                make.left.right.equalTo(container)
                make.top.bottom.equalTo(container)
            }
        } else {
            container.backgroundColor = UIColor.lightGray
            
            let imageView: UIImageView = UIImageView()
            imageView.image = UIImage(named: "placeholder_ad")
            imageView.contentMode = .scaleAspectFill
            container.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 42, height: 42))
                make.center.equalToSuperview()
            }
        }
        
    }
    
    func updateTagLabel(_ text: String) {
        var label = self.viewWithTag(1008) as? UILabel
        if self.viewWithTag(1008) == nil {
            label = UILabel()
            label!.textColor = .red
            label!.tag = 1008
            label!.numberOfLines = 0
            label!.font = .systemFont(ofSize: 20)
            label!.layer.borderWidth = 2
            label!.layer.borderColor = UIColor.red.cgColor
            self.contentView.addSubview(label!)
            label!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        label?.text = text
    }
}
