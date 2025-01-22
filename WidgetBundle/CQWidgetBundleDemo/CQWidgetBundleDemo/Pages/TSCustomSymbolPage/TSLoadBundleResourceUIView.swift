//
//  TSLoadBundleResourceUIView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/22.
//

import UIKit
import CJViewElement_Swift

import SwiftUI
import SnapKit

struct TSLoadBundleResourceViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = TSLoadBundleResourceUIView()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    /*
    @State private var labelText: String = "Hello, SwiftUI!"
    class Coordinator: NSObject {
        var parent: TSLoadBundleResourceViewRepresentable
        
        init(parent: TSLoadBundleResourceViewRepresentable) {
            self.parent = parent
        }
        
        @objc func buttonTapped() {
            parent.labelText = "Text Changed!"
        }
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    */
}

class TSLoadBundleResourceUIView: UIView {
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
        
        let png_inMainBundle_view = mainBundleImageView(name: "png_inMainBundle.png")
        stackView.addSubview(png_inMainBundle_view)
        png_inMainBundle_view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let normal_svg_inMainBundle_view = mainBundleImageView(name: "normal_svg_inMainBundle.svg")
        stackView.addSubview(normal_svg_inMainBundle_view)
        normal_svg_inMainBundle_view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(png_inMainBundle_view.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
        
        let symbol_svg_inMainBundle_view = mainBundleImageView(name: "symbol_svg_inMainBundle.svg")
        stackView.addSubview(symbol_svg_inMainBundle_view)
        symbol_svg_inMainBundle_view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(normal_svg_inMainBundle_view.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
        
        return stackView
    }
    
    private func mainBundleImageView(name: String) -> UIView {
        var image_fromName: UIImage?
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        image_fromName = UIImage(named: name, in: nil, variableValue: 0.5, configuration: configuration)
        let namedImageView = TSResourceView(imageGetMethod: "name", image: image_fromName)

        
        var image_fromData: UIImage?
        let tuple = TSResourceUtil.extractFileNameAndExtension(from: name)
        let path = Bundle.main.path(forResource: tuple.fileName, ofType: tuple.fileExtension)
        if let path = path {
            let imageData = try? Data(contentsOf: URL(fileURLWithPath: path))
            if let imageData = imageData {
                image_fromData = UIImage(data: imageData)
            }
        }
        let imageDataImageView = TSResourceView(imageGetMethod: "data", image: image_fromData)
        
        return TSResourceHorizontalView(name: name, view1: namedImageView, view2: imageDataImageView)
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


class TSResourceHorizontalView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(name: String, view1: UIView, view2: UIView) {
        super.init(frame: .zero)
        
        self.setupViews(name: name, view1: view1, view2: view2)
    }
    
    private func setupViews(name: String, view1: UIView, view2: UIView) {
        self.backgroundColor = .cyan
        
        let label = UILabel()
        label.text = name
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self)
            make.height.equalTo(20)
        }
        
        self.addSubview(view1)
        self.addSubview(view2)
        view1.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(label.snp.bottom)
            make.bottom.equalTo(self)
            make.width.equalTo(160)
        }
        
        view2.snp.makeConstraints { make in
            make.left.equalTo(view1.snp.right).offset(10)
            make.top.equalTo(view1)
            make.width.height.equalTo(view1)
        }
    }
}

class TSResourceView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageGetMethod: String, image: UIImage?) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.randomColor
        
        self.setupView(imageGetMethod: imageGetMethod, image: image)
    }
    
    private func setupView(imageGetMethod: String, image: UIImage?) {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.text = imageGetMethod
        self.addSubview(label)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.randomColor
        self.addSubview(imageView)
        
        // 设置约束
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self)
            make.height.equalTo(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
    }
}
