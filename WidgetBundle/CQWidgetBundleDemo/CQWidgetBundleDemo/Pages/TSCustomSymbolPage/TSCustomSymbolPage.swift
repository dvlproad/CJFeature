//
//  TSCustomSymbolPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//
//  测试在 SwiftUI 中，加载一张 .svg 格式的自定义 SF Symbols 图标。

import SwiftUI
import CJAnimationKit_Swift

struct TSCustomSymbolPage: View {
    
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
            systemSymbolView1
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .background(Color.red)
            
            if #available(iOS 18.0, *) {
                systemSymbolView2
                    .frame(width: UIScreen.main.bounds.width, height: 120)
                    .background(Color.red)
            }
            
            thirdSDKSymbolView
                .frame(width: UIScreen.main.bounds.width, height: 200)
                .background(Color.red)
                .clipped()
            
            // =======Failure Example:=======
            // SVG
            
            //let uiimage = SVGImageUtil.loadImageSvgName("activity_byPath")      // 不是 SF Symbol，可以加载，但需要的是 SF Symbol
            //        let uiimage = UIImage.loadImageSvgName("emoji9_FFA5BE_byPath") // SF Symbol 的 SVG 加载显示和打开看到的一样
            //        let imageView = Image(uiImage: uiimage ?? UIImage())
            
            // SVG Render
            //        let uiimage = UIImage.renderSFSymbolToImage(symbolName: "emoji9_FFA5BE_byPath", size: CGSize(width: 44, height: 44))
            //        let imageView = Image(uiImage: uiimage ?? UIImage())
            
            // PDF
            //        let imageView = Image("icons8-superman-pdf")
            //        let imageView = Image(uiImage: uiimage ?? UIImage())
            //        let uiimage = UIImage.loadPDFThumbnail(named: "icons8-ninja-turtle_byPath", size: CGSize(width: 44, height: 44
            
            // 共享目录下
            let sfsymbolPath = CJTestUtil.sfsymbolPath_inShareDir
            let uiimage_error = UIImage(contentsOfFile: sfsymbolPath)
            
            
            customRenderSymbolView
                .frame(width: UIScreen.main.bounds.width, height: 210)
                .background(Color.red)
                .clipped()
        }
    }
    
    let mainBundlePath = Bundle.main.bundlePath
    let path_fromMainBundle = Bundle.main.path(forResource: "icon_control_katong_6_byPath", ofType: "svg") ?? ""
    
    var systemSymbolView1: some View {
        HStack {
            VStack {
                Text("❌systemName")
                Image(systemName: "emoji9_FFA5BE")  // ❌自定义的 Symbol 不能用 systemName:
                    .frame(width: 60, height: 60)
                    .background(Color.randomColor)
            }
            
            VStack {
                Text("✅ name")
                Image("emoji9_FFA5BE")
                    .frame(width: 60, height: 60)
                    .background(Color.randomColor)
            }
            
            VStack {
                Text("❌bundle")
                Image("emoji9_FFA5BE_byPath", bundle: nil)
                    .frame(width: 60, height: 60)
                    .background(Color.randomColor)
            }
        }
    }
    
    @ViewBuilder
    var systemSymbolView2: some View {
        if #available(iOS 18.0, *) {
            HStack {
                VStack {
                    Text("❌systemName")
                    Image(systemName: "icon_control_katong_5")  // ❌自定义的 Symbol 不能用 systemName:
                        .resizable()
                        .applyEffect(.bounceUpByLayer)
                        .imageFrame(.rectangle)
                        .background(Color.randomColor)
                }
                VStack {
                    Text("✅ name")
                    Image("icon_control_katong_5")
                        .resizable()
                        .applyEffect(.bounceUpByLayer)
                        .imageFrame(.rectangle)
                        .background(Color.randomColor)
                }
                
                VStack {
                    Text("✅ name")
                    Label {
                        Text("标题")
                        Text("副标题")
                    } icon: {
                        // 系统SF图标
                        // Image(systemName: "figure.walk")
                        // 自定义SF图标
                        // Image(entity.imageName)
                        
                        Image("icon_control_katong_5")
                            .resizable()
                            .applyEffect(.bounceUpByLayer)
                            .imageFrame(.rectangle)
                            .background(Color.randomColor)
                        
                    }
                    .background(Color.green)
                }
            }
        } else {
            EmptyView()
        }
    }
    
    var thirdSDKSymbolView: some View {
        HStack {
            VStack {
                Text("SVGKit")
                SVGImageView(filePath: path_fromMainBundle)
                    .frame(width: 160, height: 160)
                    .background(Color.randomColor)
                    .clipped()
            }
            
            VStack {
                Text("SwiftSVG")
                //            SVGImageView2(svgName: "icon_control_katong_6")
                SwiftSVGView(svgName: "icon_control_katong_6_byPath")
                    .frame(width: 160, height: 160)
                    .background(Color.randomColor)
                    .clipped()
            }
        }
    }
    
    var customRenderSymbolView: some View {
        HStack {
            VStack {
                Text("uiimage_fromPath")
                let size = CGSize(width: 44, height: 44)
                let uiimage_fromPath = UIImage.getSFSymbol(symbolPath: path_fromMainBundle, size: size)
                Image(uiImage: uiimage_fromPath ?? UIImage())
                    .frame(width: 160, height: 160)
                    .background(Color.randomColor)
            }
            
            VStack {
                Text("uiimage_fromBundle")
                let uiimage_fromBundle = UIImage.getSFSymbol(symbolName: "icon_control_katong_6_byBundlePath", bundleName: "ShareBundle")
                Image(uiImage: uiimage_fromBundle ?? UIImage())
                    .frame(width: 160, height: 160)
                    .background(Color.randomColor)
            }
        }
    }
}
