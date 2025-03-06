//
//  ControlWidgetBottomHelpPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import Foundation
import SwiftUI

struct ControlWidgetBottomHelpPage: View {
    @Binding var isShowing: Bool
    @State var tutorialCurrentPage: Int = 0
    var isMuted: Bool = false
    var doneTitle: String = "前往桌面安装"
    
    @State var dataArray: [TutorialsItem] = [
        TutorialsItem(title: "桌面组件安装教程", subTitle: "", fileName: "tutorials"),
    ]
    
    var body: some View {
        if(isShowing) {
            ZStack(alignment: .bottom) {
                Color(hex: "#000000").opacity(isShowing ? 0.2 :0).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isShowing = false
                    }
                VStack() {
                    TabView(selection: $tutorialCurrentPage) {
                        // 每个竖向滚动的ScrollView
                        ForEach(0..<dataArray.count,id:\.self) { index in
                            ControlWidgetBottomTutorialView(
                                isShowing: $isShowing,
                                isMuted: isMuted,
                                itemModel: dataArray[index]
                            )
                        }
                    }
                    .frame(width: screenWidth)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .onChange(of: tutorialCurrentPage) { newValue in
                        tutorialCurrentPage = newValue
                    }
                    Button {
                        if doneTitle == "前往桌面安装" {
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        } else {
                            isShowing = false
                        }
                    } label: {
                        Text(doneTitle)
                            .frame(width: 270, height: 50)
                    }
                    .frame(width: 270, height: 50)
                    .background(btnBgColor)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .cornerRadius(25.0)
                    .padding(.vertical, 14)
                    
                    Spacer().frame(height: 34)
                }
                .frame(width: screenWidth, height: 429)
                .background(Color.white)
                .clipShape(RoundedCorners(tl: 14, tr: 14, bl: 0, br: 0))
                .clipped()
                
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct ControlWidgetBottomTutorialView: View {
    @Binding var isShowing: Bool
    @State var autoPlayAnimatedImage: Bool = true
    var isMuted: Bool = false
    
    let itemModel: TutorialsItem
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 30) {
                Spacer().frame(height: 8)
                
                HStack {
                    Spacer().frame(width: 56)
                    
                    Spacer()
                    
                    Text(itemModel.title)
                        .font(.system(size: 16.5,weight: .medium))
                        .foregroundColor(title1Color)
                    
                    Spacer()
                    
                    Button {
                        isShowing = false
                    } label: {
                        Image(uiImage: UIImage(named: "wi_close_gray") ?? UIImage())
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                    }
                }
                .frame(height: 20)
                
//                CustomVideoPlayer(fileName: itemModel.fileName,
//                                  size: CGSize(width: geometry.size.width - 40, height: (geometry.size.width - 40) * 0.6),
//                                  isPlaying: $isShowing,
//                                  isMuted: isMuted)
//                .frame(width: geometry.size.width - 40)
//                .cornerRadius(13.5, corners: .allCorners)
//                .clipped()
            }
        }
    }
}
