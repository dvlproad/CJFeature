//
//  NavigationBarView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/3/4.
//

import SwiftUI
import CQWidgetBundle   // 需要使用 CustomButton

let title2Color = Color(hex: "#666666")


let title4Color = Color(hex: "#CACACA")

let lineColor = Color(hex: "#EEEEEE")

let backColor = Color(hex: "#F5F5F5")

let themColor = Color(hex: "#FFE352")

let EmphasizeWordColor = Color(hex: "#FE4E38")

let cornerSmallleRate = 0.12

let cornerMediumRate = 0.05

let cornerLargeRate = 0.12

let cornerCircularRate = 0.12

let cornerRectangularRate = 0.05

let backCoverOpacity = 0.3

let widgetTopPadding: CGFloat = 20.0

let widgetPreviewBottom: CGFloat = 30.0

let widgetDetailPadding: CGFloat = 21

class EditStatusModel: ObservableObject {
    /// 是否已编辑
    var isEdited: Bool = false
    
    func didEdit() {
        isEdited = true
    }
}
extension String {
    /// 获取当前字符串的md5值
    /// - Returns: md5字符串
    public func md5() -> String {
        return self
    }
    
    /// 获取当前字符串的sha1值
    /// - Returns: sha1字符串
    public func sha1() -> String {
        return self
    }
}

extension Data {
    /// 返回UTF8字符串
    public var string: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

let screenWidth = UIScreen.main.bounds.width
let feedAdPlaceholderHeight: CGFloat = 84
func feedAdSize(horizontalPadding: CGFloat = 0) -> CGSize {
    return  CGSizeMake(screenWidth-2*horizontalPadding, feedAdPlaceholderHeight+2*10)    // 广告流的大小
}

let screenHeight = UIScreen.main.bounds.height






extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.modifier(CornerRadiusStyle(radius: radius, corners: corners))
    }
}
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content.clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}



struct NavigationBarView<RightButtonContent: View>: View {
    #if DEBUG
    @AppStorage("isShowTouch") private var isShowTouch: Bool = false
    #endif
    var title: String
    var titleViewIsLeft: Bool = false
    var rightButtonContent: RightButtonContent
    var hideBackBtn:Bool
    var leftComplete: () -> Void = { }
    init(title: String,
         titleViewIsLeft: Bool = false,
         hideBackBtn:Bool,
         @ViewBuilder rightButtonContent: () -> RightButtonContent,
         leftComplete:@escaping () -> Void = { }
    ) {
        self.hideBackBtn = hideBackBtn
        self.title = title
        self.rightButtonContent = rightButtonContent()
        self.leftComplete = leftComplete
        self.titleViewIsLeft = titleViewIsLeft
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                CustomButton(tapComplete: {
                    if(hideBackBtn == false){
                        leftComplete()
                    }
                }, labelView: {
                    if(!hideBackBtn ){
                        Image("arrow_left_black").foregroundColor(.black)
                    }
                }, bgColor: Color.clear, radius: 0)
                .frame(width: 50, height: UIDevice.xp_navigationBarHeight())
                
                if !titleViewIsLeft {
                    Spacer().frame(width: 70)
                    Spacer()
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#333333"))
                #if DEBUG
                    .onTapGesture(count: 3) {
                        isShowTouch.toggle()
                    }
                #endif
                Spacer()
                
                HStack(content: {
                    Spacer()
                    rightButtonContent
                        .frame(height: UIDevice.xp_navigationBarHeight())
                }).frame(width: 120)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIDevice.xp_navigationBarHeight())
            .padding(.top,UIDevice.xp_statusBarHeight())
        }
    }
}



