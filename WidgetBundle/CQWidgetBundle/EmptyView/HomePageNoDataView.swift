//
//  HomePageNoDataView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/3/6.
//

import SwiftUI
import Lottie

public struct HomePageNoDataView:View {
    @Binding  var noDataType: Int //0 无数据 1 无网络 2 加载中
    var tip: String = ""
    var retryComplete:()->Void = {}
    
    // MARK: - Init
    public init(
        noDataType: Binding<Int>,
        tip: String = "",
        retryComplete: @escaping () -> Void = {}
    ) {
        self._noDataType = noDataType
        self.tip = tip
        self.retryComplete = retryComplete
    }
    
    public var body: some View {
        var content: String {
            guard tip.count == 0 else {
                return tip
            }
            switch noDataType {
            case 0:
                return "暂无任何数据"
            case 1:
                return "无网络链接"
            case 2:
                return "数据加载中..."
            default:
                return "暂无任何数据"
            }
        }
        VStack(spacing: 0){
            if(noDataType == 2){
                LottiePlayView(filename: "loading")
                    .frame(width: 30.cj_width, height: 30.cj_width)
            }else{
                Image(noDataType == 0 ?"myWidget_noData":"noNet")
                    .resizable()
                    .frame(width: 209,height: 157)
            }
            Spacer()
                .frame(height: 27)
            Text(content)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#999999"))
            if(noDataType == 1 || noDataType == 0){
                CustomButton(tapComplete: {
//                    adConfigApi()
                    retryComplete()
                }, labelView: {
                    Text("重试")
                        .font(.system(size: 14,weight: .medium))
                        .foregroundColor(.white)
                }, bgColor:Color(hex: "#2E2E2E") , radius: 38 / 2)
                .frame(width: 157,height: 38)
                .padding(.top,27)
            }
            Spacer()
                .frame(height: 40)
        }
        .padding(.bottom,50)
    }
}
struct LottiePlayView: UIViewRepresentable {
    var filename: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animation = LottieAnimationView(name: filename)
        animation.contentMode = .scaleAspectFit
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.loopMode = .loop // 设置为无限循环
        animation.play()
        view.addSubview(animation)
        NSLayoutConstraint.activate([
            animation.heightAnchor.constraint(equalTo: view.heightAnchor),
            animation.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // 动画视图更新逻辑（如果需要）
    }
}
