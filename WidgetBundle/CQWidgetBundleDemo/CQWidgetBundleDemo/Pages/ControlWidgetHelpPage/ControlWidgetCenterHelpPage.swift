//
//  ControlWidgetCenterHelpPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation
import SwiftUI

struct TutorialsItem {
    var title: String
    var subTitle: String
    var fileName: String
}


struct ControlWidgetCenterHelpPage: View {
    var viewWidth: CGFloat = 300
    var contentHeight: CGFloat // 不包含底部 我知道了 按钮之外的其他视图的高度
    
    @Binding var isShowing: Bool
    @State var tutorialCurrentPage: Int = 0
    var isMuted: Bool = false
    var doneTitle: String
    
    @State var dataArray: [TutorialsItem]
    
    var body: some View {
        if(isShowing) {
            ZStack(alignment: .center) {
                Color(hex: "#000000").opacity(isShowing ? 0.2 :0).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isShowing = false
                    }
                
                VStack(spacing: 0) {
                    TabView(selection: $tutorialCurrentPage) {
                        // 每个竖向滚动的ScrollView
                        ForEach(0..<dataArray.count,id:\.self) { index in
                            ControlWidgetCenterTutorialView(
                                isShowing: $isShowing,
                                isMuted: isMuted,
                                itemModel: dataArray[index]
                            )
                        }
                    }
                    .frame(height: contentHeight)
                    //.background(Color.blue)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .onChange(of: tutorialCurrentPage) { newValue in
                        tutorialCurrentPage = newValue
                    }
                    
                    Button {
                        isShowing = false
                    } label: {
                        Text(doneTitle)
                            .frame(width: 250)
                    }
                    .frame(height: 40)
                    .background(btnBgColor)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .cornerRadius(20.0)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20) // 按钮上下各留20间距
                }
                .frame(width: viewWidth)
                .background(Color.white)
                .clipShape(RoundedCorners(tl: 12.5, tr: 12.5, bl: 12.5, br: 12.5))
                .clipped()
                
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct ControlWidgetCenterTutorialView: View {
    @Binding var isShowing: Bool
    @State var autoPlayAnimatedImage: Bool = true
    var isMuted: Bool = false
    let itemModel: TutorialsItem
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    Spacer()
                    
                    Text(itemModel.title)
                        .font(.system(size: 16.5, weight: .medium))
                        .foregroundColor(title1Color)
                    
                    Spacer()
                    
                    Button {
                        isShowing = false
                    } label: {
                        Image(uiImage: UIImage(named: "wi_close_gray") ?? UIImage())
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                    }
                }
                .frame(height: 40)
                .padding(.top, 0)
                
//                CustomVideoPlayer(
//                    fileName: itemModel.fileName,
//                    size: CGSize(width: geometry.size.width - 40, height: (geometry.size.width - 40) * 0.6),
//                    isPlaying: $isShowing,
//                    isMuted: isMuted
//                )
//                .frame(height: 154)
//                .padding(.horizontal, 20)
//                .cornerRadius(13.5, corners: .allCorners)
//                .clipped()
                
                widgetStyleHelpTextView
                    .frame(height: 32)
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
            }
        }
    }
    
    var widgetStyleHelpTextView: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("当前尺寸切换仅为预览效果，在控制中心安装时请")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#333333"))
                +
                Text("拉拽控制的右下角")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#FE4E38"))
                    //.underline()
                    //.onTapGesture {
                    //
                    //}
                +
                Text("调整至所需的尺寸")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#333333"))
            }
            
//            HStack(alignment: .center, spacing: 0) {
//                Text("输入。")
//                    .font(.system(size: 12, weight: .medium))
//                    .foregroundColor(Color(hex: "#333333"))
//                Text("了解更多")
//                    .font(.system(size: 12, weight: .medium))
//                    .foregroundColor(Color(hex: "#FE4E38"))
//                    .underline()
//                    .onTapGesture {
//                        TSToastUtil.showTodo("了解更多")
//                    }
//            }
        }
    }
}
