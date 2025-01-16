//
//  CustomSymbolView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//
//  在 SwiftUI 中，加载一张 .svg 格式的自定义 SF Symbols 图标。

import SwiftUI
import SVGKit
import SwiftSVG

// 创建一个使用 SVGKit 的 UIViewRepresentable
struct SVGImageView: UIViewRepresentable {
    var filePath: String

    func makeUIView(context: Context) -> SVGKFastImageView {
        let svgImageView = SVGKFastImageView(frame: .zero)
        if let svgImage = SVGKImage(contentsOfFile: filePath) {
            svgImageView.image = svgImage
        }
        return svgImageView
    }

    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        // 更新视图，如果有需要的话
    }
}


struct SwiftSVGView: UIViewRepresentable {
    let svgName: String

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        // 尝试加载 SVG 文件
        if let url = Bundle.main.url(forResource: svgName, withExtension: "svg") {
            let svgView = UIView(SVGURL: url) { image in
                image.resizeToFit(containerView.bounds)
            }
            svgView.contentMode = .scaleAspectFit
            svgView.translatesAutoresizingMaskIntoConstraints = false

            containerView.addSubview(svgView)

            NSLayoutConstraint.activate([
                svgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                svgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                svgView.topAnchor.constraint(equalTo: containerView.topAnchor),
                svgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        }

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 无需动态更新
    }
}


struct SVGImageView2: View {
    let svgName: String
    
    var body: some View {
        if let svgImage = SVGKImage(named: svgName) {
            // 确保正确缩放到合适的尺寸
            Image(uiImage: svgImage.uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            // 如果加载失败，可以显示占位符
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
        }
    }
}
