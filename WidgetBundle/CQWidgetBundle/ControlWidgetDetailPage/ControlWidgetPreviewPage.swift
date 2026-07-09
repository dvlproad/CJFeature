//
//  ControlWidgetPreviewPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/17.
//
//  预览页

import SwiftUI
import CQWidgetBundleCommon

public struct ControlWidgetPreviewPage: View {
    @Binding var entity: BaseControlWidgetEntity
    
    public init(
        entity: Binding<BaseControlWidgetEntity>
    ) {
        self._entity = entity
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            Image("previewBG_controlWidget")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all) // 忽略安全区，让图片覆盖整个屏幕

            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 368)
                
                let squareImageWidth = 143.5+6   // 正方形图片大小
                let imageHorizonSpacing = 14.5+6
                let imageVerticalSpacing = imageHorizonSpacing
                let samllImageHeight = (squareImageWidth-imageVerticalSpacing)/2.0
                
                HStack(alignment: .top, spacing: 0) {
                    let squareEntity = entity.copyWithNewWidgetStyle(.square)
                    let rectangleEntity = entity.copyWithNewWidgetStyle(.rectangle)
                    let circleEntity = entity.copyWithNewWidgetStyle(.circle)
                    
                    BaseControlWidgetViewInApp(entity: squareEntity, pageInfo: CCPageInfo(pageType: .controlWidgetPerviewPage))
                        .frame(width: squareImageWidth, height: squareImageWidth)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        BaseControlWidgetViewInApp(entity: rectangleEntity, pageInfo: CCPageInfo(pageType: .controlWidgetPerviewPage))
                            .frame(width: squareImageWidth, height: samllImageHeight)
                        
                        BaseControlWidgetViewInApp(entity: circleEntity, pageInfo: CCPageInfo(pageType: .controlWidgetPerviewPage))
                            .frame(width: samllImageHeight, height: samllImageHeight)
                            .padding(.top, imageVerticalSpacing)
                    }
                    .padding(.leading, imageHorizonSpacing)
                }
                .frame(width: squareImageWidth+imageHorizonSpacing+squareImageWidth, height: squareImageWidth)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
            //.background(Color.yellow.opacity(0.2))
        }
    }
}
