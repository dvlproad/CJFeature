//
//  TSCustomSymbolPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//
//  测试在 SwiftUI 中，加载一张 .svg 格式的自定义 SF Symbols 图标。

import SwiftUI
import CJAnimationKit_Swift
import SwiftDraw

struct TSCustomSymbolInBundlePage: View {
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                Text("Asset外的 .svg 格式的自定义 SF Symbols 图标加载")
                
                ScrollView(.vertical) {
                    contentView
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color(hex: "#F5F5F5"))
            .padding(.top, 0)
            .padding(.bottom, 80)
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 10) {
            mainBundleImage(name: "png_inMainBundle.png")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            mainBundleImage(name: "normal_svg_inMainBundle.svg")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            mainBundleImage(name: "symbol_svg_inMainBundle.svg")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            downloadedBundleImage(name: "png_inDesignatedBundle.png")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            downloadedBundleImage(name: "normal_svg_inDesignatedBundle.svg")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            downloadedBundleImage(name: "symbol_svg_inDesignatedBundle.svg")
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
        }
    }
    
    func mainBundleImage(name: String) -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(name)")
            HStack {
                VStack {
                    TSText("named")
                    let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
                    let image = UIImage(named: name, in: nil, variableValue: 0.5, configuration: configuration)
                    Image(uiImage: image ?? UIImage())
                        .frame(width: 60, height: 60)
                        .background(Color.randomColor)
                }
                
                VStack {
                    TSText("imageData")
                    
                    let tuple = TSResourceUtil.extractFileNameAndExtension(from: name)
                    let path_fromMainBundle = Bundle.main.path(forResource: tuple.fileName,
                                                               ofType: tuple.fileExtension)
                    if path_fromMainBundle != nil {
                        let uiimage_fromPath = UIImage.loadImageDataInPath(path_fromMainBundle!)
                        Image(uiImage: uiimage_fromPath ?? UIImage())
                            .frame(width: 60, height: 60)
                            .background(Color.randomColor)
                    } else {
                        Text("Failed to load image")
                    }
                }
            }
        }
    }
    
    func downloadedBundleImage(name: String) -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(name)")
            HStack {
                VStack {
                    Text("❌bunlde")
                    if let downloadedBundle = TSResourceUtil.downloadedBundle {
                        Image(name, bundle: downloadedBundle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .background(Color.randomColor)
                    } else {
                        Text("Failed to load bundle")
                    }
                }
                
                
                VStack {
                    Text("✅ path")
                    let downloadedBundle_UIImage = TSResourceUtil.downloadedBundle_UIImage(name: name)
                    Image(uiImage: downloadedBundle_UIImage ?? UIImage())
                        .frame(width: 60, height: 60)
                        .background(Color.randomColor)
                }
                
//            VStack {
//                Text("❌bundle")
//                Image("emoji9_FFA5BE_byPath", bundle: nil)
//                    .frame(width: 60, height: 60)
//                    .background(Color.randomColor)
//            }
            }
        }
    }
}
