//
//  SVGImageView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//

import SwiftUI
import SVGKit

// MARK: SF Symbol
extension UIImage {
    // 渲染 SF Symbol 图标为 UIImage
    static func getSFSymbol(symbolPath: String, size: CGSize) -> UIImage? {
        guard let svgImage = SVGKImage(contentsOfFile: symbolPath) else {
            return nil
        }
        
        let uiimage = renderSVGKImage(svgImage, size: size)
        return uiimage
    }
    
    static func renderSVGKImage(_ svgImage: SVGKImage, size: CGSize) -> UIImage {
        // 使用 UIGraphicsImageRenderer 渲染为指定大小的图像
        // 设置 SF Symbol 样式，如颜色、大小
        svgImage.size = size  // 调整大小
//        svgImage.fillColor = .systemBlue  // 假设应用系统颜色
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { _ in
//            svgImage.draw(in: CGRect(origin: .zero, size: size))
            svgImage.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        return renderedImage
    }
}

// MARK: SVG
extension UIImage {
    static func loadImageSvgName(_ svgName: String) -> UIImage? {
//        guard let url = Bundle.main.url(forResource: svgName, withExtension: "svg") else {
//            fatalError("SVG file not found")
//        }
//        let svgImage = SVGKImage(contentsOf: url)
        
        guard let path = Bundle.main.path(forResource: svgName, ofType: "svg") else {
            fatalError("SVG file not found")
        }
        let svgImage = SVGKImage(contentsOfFile: path)
        
        return svgImage?.uiImage
    }
}

// MARK: PDF
import UIKit
import CoreGraphics
extension UIImage {
    static func loadPDFThumbnail(named fileName: String, size: CGSize) -> UIImage? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "pdf"),
              let pdfDocument = CGPDFDocument(url as CFURL),
              let pdfPage = pdfDocument.page(at: 1) else { // 加载 PDF 的第一页
            print("PDF 文件加载失败")
            return nil
        }

        // 创建绘制上下文
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let ctx = context.cgContext
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fill(CGRect(origin: .zero, size: size))

            let pdfBox = pdfPage.getBoxRect(.mediaBox)
            let scale = min(size.width / pdfBox.width, size.height / pdfBox.height)
            ctx.saveGState()
            ctx.translateBy(x: 0, y: size.height)
            ctx.scaleBy(x: 1, y: -1) // 翻转 Y 轴以适配 UIKit 坐标系
            ctx.scaleBy(x: scale, y: scale)
            ctx.drawPDFPage(pdfPage)
            ctx.restoreGState()
        }
        return image
    }
}
