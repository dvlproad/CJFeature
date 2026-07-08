//
//  View+ControlWidget.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI

public extension UIImage {
    static func getControlWidgetUIImageFrom(_ uiimage: UIImage, tintColor: UIColor?, bgColor: UIColor) -> UIImage {
        var lastuiimage: UIImage
        let bgSize: CGFloat = 33.0
        let imageWidthHeightRatio: CGFloat = uiimage.size.width / uiimage.size.height
        var imageWidth: CGFloat
        var imageHeight: CGFloat
        if (imageWidthHeightRatio > 1.0) {
            imageWidth = bgSize * 0.9
            imageHeight = imageWidth / imageWidthHeightRatio
        } else {
            imageHeight = bgSize * 0.9
            imageWidth = imageHeight * imageWidthHeightRatio
        }
        if let imageResize = uiimage.resizeToSize(newSize: CGSize(width: imageWidth, height: imageHeight)) {
            if let tintColor = tintColor {
                if let tintedImage = imageResize.applyTintColor(tintColor) {
                    let imageWithBackground = tintedImage.addBackgroundColor(
                        bgColor,
                        backgroundSize: CGSize(width: bgSize, height: bgSize),
                        imageSize: CGSize(width: imageWidth, height: imageHeight),
                        cornerRadius: bgSize/2.0
                    )
                    lastuiimage = imageWithBackground
                } else {
                    lastuiimage = imageResize
                }
            } else {
                lastuiimage = imageResize
            }
        } else {
            lastuiimage = uiimage
        }
        return lastuiimage
    }
    
    // 为图片添加背景色和圆角的方法
    func addBackgroundColor(_ backgroundColor: UIColor,
                            backgroundSize: CGSize,
                            imageSize: CGSize? = nil,
                            cornerRadius: CGFloat) -> UIImage {
        
        // 如果 backgroundSize 为空，使用图像大小
        var backgroundSize = backgroundSize
        if backgroundSize == CGSize.zero {
            backgroundSize = self.size
        }
        
        // 如果 imageSize 为空，使用图像原始大小
        let imageSize = imageSize ?? self.size
        
        // 创建一个新的图形上下文，使用背景大小
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, self.scale)
        
        // 设置圆角路径
        let rect = CGRect(x: 0, y: 0, width: backgroundSize.width, height: backgroundSize.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()  // 设置圆角裁剪
        
        // 设置背景色
        backgroundColor.setFill()
        UIRectFill(rect)
        
        // 计算图像的位置，确保它居中
        let imageRect = CGRect(x: (backgroundSize.width - imageSize.width) / 2,
                               y: (backgroundSize.height - imageSize.height) / 2,
                               width: imageSize.width,
                               height: imageSize.height)
        
        // 绘制原始图片（按照指定的 imageSize 绘制）
        self.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        
        // 获取添加了背景色、圆角后的图像
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 如果生成失败，返回原图
        return newImage ?? self
    }
    
    func resizeToSize(newSize: CGSize) -> UIImage? {
        // 创建一个适当大小的位图上下文
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        
        // 将原始图像绘制到新上下文中
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        // 从当前上下文中获取修改后的图像
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    // 为图片添加 tintColor 的方法
    @objc func applyTintColor(_ tintColor: UIColor) -> UIImage? {
        // We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        // Fill the context with the tint color
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        
        // Draw the tinted image in context
        self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        
        // Get the tinted image from the current context
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
    
}
