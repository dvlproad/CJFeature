//
//  NavigationBarView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/3/4.
//

import SwiftUI


let title1Color = Color(hex: "#333333")

let title2Color = Color(hex: "#666666")

let title3Color = Color(hex: "#999999")

let title4Color = Color(hex: "#CACACA")

let lineColor = Color(hex: "#EEEEEE")

let backColor = Color(hex: "#F5F5F5")

let themColor = Color(hex: "#FFE352")

let EmphasizeWordColor = Color(hex: "#FE4E38")

let btnBgColor = Color(hex: "#2E2E2E")

let cornerSmallleRate = 0.12

let cornerMediumRate = 0.05

let cornerLargeRate = 0.12

let cornerCircularRate = 0.12

let cornerRectangularRate = 0.05

let backCoverOpacity = 0.3

let widgetTopPadding: CGFloat = 20.0

let widgetPreviewBottom: CGFloat = 30.0

let widgetDetailPadding: CGFloat = 21

import Combine
class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}

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

func fontAdapt(_ zitidaxiao: CGFloat) -> CGFloat {
    return (zitidaxiao / 834.0) * UIScreen.main.bounds.height
}
func adaptedSizeWidth(_ size: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width / 375 * size
}


struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Top left corner
        path.move(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        // Top right corner
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)

        // Bottom right corner
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        // Bottom left corner
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        // Close the path
        path.closeSubpath()

        return path
    }
}



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


extension View {
  func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
    modifier(OnFirstAppear(action: action))
  }
}
private struct OnFirstAppear: ViewModifier {
    let action: (() -> Void)?
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action?()
            }
        }
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
                    .foregroundColor(title1Color)
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


struct CustomButton<LabelView:View>: View {
    let labelView: LabelView
    var tapComplete: () -> Void = { }
    let bgColor:Color
    let radius:CGFloat
    // 使用 @ViewBuilder 来允许传入自定义的视图
    init(tapComplete:@escaping () -> Void = { },
         @ViewBuilder labelView: () -> LabelView,
         bgColor:Color,
         radius:CGFloat
    ) {
        self.tapComplete = tapComplete
        self.labelView = labelView()
        self.bgColor = bgColor
        self.radius = radius
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            Button(action: {
                tapComplete()
            }, label: {
                ZStack {
                    Rectangle() // 可以是透明的，用于确保点击事件被捕捉
                        .foregroundColor(.clear)
                        .contentShape(Rectangle()) // 确保整个区域都是可点击的
                    labelView
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 使用最大尺寸填充按钮
                }
            })
            .frame(width: geometry.size.width,height: geometry.size.height)
            .background(bgColor)
            .cornerRadius(radius)
            .buttonStyle(StaticButtonStyle())
        })
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

