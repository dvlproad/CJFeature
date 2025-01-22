//
//  TSSwiftSVGLoadBundleResoureUIView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/22.
//

import UIKit
import CJViewElement_Swift

import SwiftUI
import SnapKit

struct TSSwiftSVGLoadBundleResoureViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = TSSwiftSVGLoadBundleResoureUIView()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

class TSSwiftSVGLoadBundleResoureUIView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = self
        
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        
        // 创建主滚动视图
        let scrollView = UIView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 添加标题
        let titleLabel = UILabel()
        titleLabel.text = "Asset外的 .svg 格式的自定义 SF Symbols 图标加载"
        titleLabel.numberOfLines = 0
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        // 添加内容视图
        let contentStackView = createContentView()
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    
    
    private func createContentView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        
        
        let png_inMainBundle_view = mainBundleSVGImageView(name: "png_inMainBundle.png")
        stackView.addSubview(png_inMainBundle_view)
        png_inMainBundle_view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let normal_svg_inMainBundle_view = mainBundleSVGImageView(name: "normal_svg_inMainBundle.svg")
        stackView.addSubview(normal_svg_inMainBundle_view)
        normal_svg_inMainBundle_view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(png_inMainBundle_view.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
        
        let symbol_svg_inMainBundle_view = mainBundleSVGImageView(name: "symbol_svg_inMainBundle.svg")
        stackView.addSubview(symbol_svg_inMainBundle_view)
        symbol_svg_inMainBundle_view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(normal_svg_inMainBundle_view.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
        
        return stackView
    }
    
    private func mainBundleSVGImageView(name: String) -> UIView {
        let tuple = TSResourceUtil.extractFileNameAndExtension(from: name)
        let imageName = tuple.fileName
        let iamgeExtension = tuple.fileExtension
        
        let svgImageView_fromName = UIView(SVGNamed: name)
        
        
        var svgImageView_fromURL: UIView = UIView()
        if let url = Bundle.main.url(forResource: imageName, withExtension: iamgeExtension) {
            svgImageView_fromURL = UIView(SVGURL: url, completion: { image in
//                image.resizeToFit(containerView.bounds)
            })
        }
        
        return TSResourceHorizontalView(name: name, view1: svgImageView_fromName, view2: svgImageView_fromURL)
    }
    
    private func downloadedBundleImageView(name: String) -> UIView {
        var image_fromName: UIImage?
        if let bundle = TSResourceUtil.downloadedBundle {
            image_fromName = UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        let namedImageView = TSResourceView(imageGetMethod: "name", image: image_fromName)

        var image_fromData: UIImage?
        let tuple = TSResourceUtil.extractFileNameAndExtension(from: name)
        let path = Bundle.main.path(forResource: tuple.fileName, ofType: tuple.fileExtension)
        image_fromData =  TSResourceUtil.downloadedBundle_UIImage(name: name)
        let imageDataImageView = TSResourceView(imageGetMethod: "data", image: image_fromData)
        
        return TSResourceHorizontalView(name: name, view1: namedImageView, view2: imageDataImageView)
    }
}
