//
//  BaseSheetPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/13.
//

import SwiftUI
//import CJBaseUIKit
import CJBaseUIKit_Swift

struct BaseSheetPage<Content>: View where Content: View {
    @Binding var isShowing:Bool
    
//    let title: String
    
    // 记录手势的偏移量
    @State private var dragOffset: CGFloat = 0
    @State private var offsetY:CGFloat = 499
    @State private var opacity:CGFloat = 0
    
    var hideTopLine: Bool // 是否隐藏顶部横岗
    var hideToolbar: Bool = false // 是否隐藏顶部整个工具条
    var toolBottomToContentTop: CGFloat // tool底部到content顶部的距离
    var title: String
    var onCancelBlock: (() -> Void)?
    var onConfirmBlock: () -> Void
    var content: Content
    var contentHeight: CGFloat
    // 初始化时，使用 @ViewBuilder 允许传入视图
    init(isShowing : Binding<Bool>,
         hideTopLine: Bool,
         toolBottomToContentTop: CGFloat,
         title: String,
         onCancelBlock: (() -> Void)? = nil,
         onConfirmBlock: @escaping () -> Void,
         contentHeight: CGFloat,
         @ViewBuilder content: () -> Content
    ) {
        self._isShowing = isShowing
        self.hideTopLine = hideTopLine
        self.hideToolbar = false
        self.toolBottomToContentTop = toolBottomToContentTop
        self.title = title
        self.onCancelBlock = onCancelBlock
        self.onConfirmBlock = onConfirmBlock
        self.contentHeight = contentHeight
        self.content = content()
    }
    
    init(isShowing : Binding<Bool>,
         hideTopLine: Bool,
         toolBottomToContentTop: CGFloat,
         contentHeight: CGFloat,
         @ViewBuilder content: () -> Content
    ) {
//        UIColor.cjColor(hexStringColor: <#T##String#>, alpha: <#T##CGFloat#>)
        self._isShowing = isShowing
        self.hideTopLine = hideTopLine
        self.hideToolbar = true
        self.toolBottomToContentTop = toolBottomToContentTop
        self.title = ""
        self.onCancelBlock = nil
        self.onConfirmBlock = {}
        self.contentHeight = contentHeight
        self.content = content()
    }
    
    var body: some View {
        let safeAreaBottom = 34.0
        
        ZStack(alignment: .bottom) {
            Color.black.opacity(opacity).edgesIgnoringSafeArea(.all) // 设置背景色
            Rectangle() // 可以是透明的，用于确保点击事件被捕捉
                .foregroundColor(.clear)
                .contentShape(Rectangle()) // 确保整个区域都是可点击的
                .onTapGesture {
                    isShowing = false
                }
            
            let topLineHeight = 4.5
            let topToContent = 14.0 + (hideTopLine == true ? 0.0 : 1.0+topLineHeight) + (hideToolbar == true ? 0.0 : 44.0) + toolBottomToContentTop // 顶部到内容的间距
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    Rectangle() // 可以是透明的，用于确保点击事件被捕捉
                        .foregroundColor(.clear)
                        .contentShape(Rectangle()) // 确保整个区域都是可点击的
                    VStack(alignment: .center, spacing: 0){
                        Spacer(minLength: 0).frame(height: 14.0)
                        
                        if hideTopLine != true {
                            RoundedRectangle(cornerRadius: topLineHeight/2.0, style: .continuous)
                                .fill(Color(hex: "#D3D3D3"))
                                .frame(width: 37, height: topLineHeight)
                                //.background(Color.green)
                                .padding(.top, 1.0)
                        }
                        
                        if hideToolbar != true {
                            SheetToolbarView(
                                title: title,
                                onCancelBlock: {
                                    isShowing = false
                                    onCancelBlock?()
                                },
                                onConfirmBlock: {
                                    isShowing = false
                                    onConfirmBlock()
                                }
                            )
                            .frame(height: 44)
                        }
                        
                        // 渲染外部传递的视图
                        content
                            .frame(width: screenWidth, height: contentHeight)
                            .padding(.top, toolBottomToContentTop)
                        
                        Spacer() // 填充剩余空间
                    }
                }
                
                .background(Color.white)
                .cornerRadius(14, corners: [.topLeft,.topRight])
                .offset(y:dragOffset > 0 ? dragOffset : 0)
                .animation(.spring())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 计算手势的偏移量，限制最大为整个视图高度的一半
                            let yOffset = value.translation.height
                            dragOffset = yOffset
                        }
                        .onEnded { value in
                            // 如果手势偏移量超过视图高度的一半，则隐藏视图
                            if dragOffset > 10 {
                                dragOffset = geometry.size.height
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isShowing = false
                                }
                            }else{
                                dragOffset = 0
                            }
                        }
                )
            }
            .frame(width: screenWidth, height: contentHeight + topToContent + safeAreaBottom) // + topToContent 顶部显示偏大
            .offset(y:offsetY)
            .clipped()
        }
        .edgesIgnoringSafeArea(.all)    // 让内容可以扩展到安全区域
        .onAppear() {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                offsetY = 0
                opacity = 0.6
            }
        }
        .onDisappear {
            // 当视图消失时，动画移到底部
            withAnimation {
                offsetY = 499
                opacity = 0
            }
        }
    }
}



// 扩展 View 类型，添加 title 头部
extension View {
//    func makeupToSheet(_ title: String, onTapTitle: (() -> Void)? = nil) -> some View {
//        HStack(alignment: .center, spacing: 0) {
//            GeometryReader { geometry in
//                Text(title)
//                    .foregroundColor(Color(hex: "#333333"))
//                    .font(.system(size: 15.5, weight: .medium))
//                    .frame(height: geometry.size.height)
//                    .onTapGesture {
//                        onTapTitle?()
//                    }
//            }
//            .frame(width: titleWidth)
//
//            self // 将原始视图放在 title 后面
//        }
//    }
}
