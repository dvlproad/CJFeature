//
//  TSThirdSwiftDrawPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/22.
//
//  测试在 SwiftUI 中，加载一张 .svg 格式的自定义 SF Symbols 图标。

import SwiftUI
import SwiftSVG

struct TSThirdSwiftSVGPage: View {
    
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
            mainBundleImage_swiftDrawView(name: "activity_byPath.svg")
                .frame(width: UIScreen.main.bounds.width, height: 210)
                .background(Color.red)
                .clipped()
            
            mainBundleImage_swiftDrawView(name: "icon_control_katong_6_byPath.svg")
                .frame(width: UIScreen.main.bounds.width, height: 210)
                .background(Color.red)
                .clipped()
            
            downloadBundleImage_swiftDrawView(name: "activity_byBundlePath.svg")
                .frame(width: UIScreen.main.bounds.width, height: 210)
                .background(Color.red)
                .clipped()
            
            downloadBundleImage_swiftDrawView(name: "icon_control_katong_6_byBundlePath.svg")
                .frame(width: UIScreen.main.bounds.width, height: 210)
                .background(Color.red)
                .clipped()
        }
    }
    
    func mainBundleImage_swiftDrawView(name: String) -> some View {
        let imageSize: CGFloat = 100.0
        return HStack {
            VStack {
                Text("svgNamed")
//                let uiimage_fromPath = UIImage(svgNamed: name)
                SwiftSVGView(svgName: "icon_control_katong_6_byPath")
                    .frame(width: imageSize, height: imageSize)
                    .background(Color.randomColor)
                    .clipped()
            }
            
            VStack {
                Text("svg -> uiimage")
//                let svg = SVG(named: name, in: .main)!
//                let uiimage_fromPath = svg.rasterize()
//                Image(uiImage: uiimage_fromPath)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: imageSize, height: imageSize)
//                    .background(Color.randomColor)
            }
        }
    }
    
    func downloadBundleImage_swiftDrawView(name: String) -> some View {
        let imageSize: CGFloat = 100.0
        return HStack {
            VStack {
                Text("svgNamed")
//                let uiimage_fromPath = UIImage(svgNamed: name, in: TSResourceUtil.downloadedBundle!)
//                Image(uiImage: uiimage_fromPath ?? UIImage())
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: imageSize, height: imageSize)
//                    .background(Color.randomColor)
            }
            
            VStack {
                Text("svg -> uiimage")
//                let svg = SVG(named: name, in: TSResourceUtil.downloadedBundle!)!
//                let uiimage_fromPath = svg.rasterize()
//                Image(uiImage: uiimage_fromPath)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: imageSize, height: imageSize)
//                    .background(Color.randomColor)
            }
        }
    }
}
