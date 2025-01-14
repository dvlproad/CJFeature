//
//  TSControlWidgetDetailPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift
import WidgetKit
import CJImageKit_Swift
import CJAnimationKit_Swift

//struct BounceModifier: ViewModifier {
//    @Binding var bounce: Bool
//    
//    func body(content: Content) -> some View {
//        content
//            .offset(y: bounce ? -20 : 0)
//            .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: bounce)
//    }
//}

struct TSControlWidgetDetailPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    var fromPageType: CQPageType
    @State var entity: BaseControlWidgetEntity
    
    @State private var showAnimationSheet: Bool = false
    
    init(fromPageType: CQPageType, entity: BaseControlWidgetEntity) {
        self.fromPageType = fromPageType
        self.entity = entity
    }
    
    var hasAdd: Bool {
        var hasAdd: Bool = false
        if let saveId = entity.saveId, saveId.count > 0 {
            hasAdd = true
        }
        return hasAdd
    }
    
    var gifImage: some View {
        CJAnimateImageViewRepresentable(
            gifName: "Ayaka",
            contentMode: .scaleAspectFill,
            isAnimating: .constant(true)
        )
        .frame(width: 150, height: 150)
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
    }
    
    @State var animationType: AnimationType = .none
    @State private var bounce = false   // 是否弹跳
    @State private var swing = false    // 是否摆动
    @State private var rotate = false   // 是否旋转
    @State private var breathe = false  // 是否呼吸
    @State private var pulse = false    // 是否脉冲
    
    private var options: [SymbolEffectType] = [
        .none,
        .bounceUpByLayer,
        .wiggleForwardByLayer,
        .rotateClockwiseByLayer,
        .breathePlainByLayer,
        .pulse
    ]
    
    
    let horizontalPadding: CGFloat = 20.0
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("\(entity.id)当前数据为: \(entity.title)")
            
            headerView
            
            ScrollView(.vertical) {
                settingView
            }
            .padding(.horizontal, horizontalPadding)
            
            addOrUpdateButton
        }
        .padding(.horizontal, horizontalPadding)
        .sheet(isPresented: $showAnimationSheet) {
            AnimationSheet(options: options, selectedIndex: animationSelectedIndex, onChangeOfIndex: { index in
                entity.symbolEffectType = options[index]
            }, onCancelBlock: {
                entity.symbolEffectType = options[animationSelectedIndex]
                showAnimationSheet = false
            }, onConfirmBlock: { newSelectedIndex in
                animationSelectedIndex = newSelectedIndex
                showAnimationSheet = false
            })
//            .presentationDetents([.medium, .large])
//            .presentationDetents(Set(heights))
            .presentationDetents([.height(400), .height(600)])

        }
        .onAppear() {
            viewOnAppear()
        }
        .task {
            
        }
    }
    let heights = stride(from: 0.1, to: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    @State var styleSelectedIndex: Int = 0
    @State var animationSelectedIndex: Int = 0
    private func updateUI() {
        animationType = entity.animateModel.type
    }
    
    @State var egIconModels: [CJBaseDataModel] = []
    @State var currentIconModel: CJBaseDataModel?
    func viewOnAppear() {
        print("TSControlWidgetDetailPage onAppear")
        bounce = true
        swing = true
        rotate = true
        breathe = true
        pulse = true
        
        egIconModels = CQControlWidgetExample.iconExamples()
        currentIconModel = egIconModels[0]
    }
    
    
    var headerView: some View {
        VStack {
            Spacer().frame(height: 20)
            
            //List {
                VStack(alignment: .center, spacing: 0) {
                    BaseControlWidgetView(bindingEntity: $entity)
                }
                .frame(height: 150)
            //}

            Spacer().frame(height: 20)
            
            StyleSegmentedView(
                options: ControlWidgetType.allCases,
                selectedIndex: styleSelectedIndex,
                onChangeOfIndex: { index in
                    styleSelectedIndex = index
                    entity.widgetStyle = ControlWidgetType.allCases[index]
                }
            )
            .frame(width: 200)
            
            Spacer().frame(height: 20)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)))
    }
    
    var settingView: some View {
        VStack {
            iconChooseView
            
            chooseAnimationButton
            
            titleEditView
            subTitleEditView
            
            
            HStack {
                Image("icon_control_katong_5")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .rotateAnimation($rotate)
//                    .onTapGesture {
//                        rotate.toggle()
//                    }
//                gifImage
//                    .bounceAnimation($bounce)
                Image("icon_control_katong_6")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
//                        .bounceAnimation($bounce)
                    .bounceAnimation(.constant(animationType == .bounce))
                    .rotateAnimation(.constant(animationType == .rotate))
                    .cjAnimation(type: $animationType)
            }
            .background(Color.gray)
            .clipped()
        }
    }
    
    var iconChooseView: some View {
        VStack(alignment: .center, spacing: 0) {
            TitleRowView(title: "图标", value: "图标库", onTapValue: {
                showAnimationSheet.toggle()
            })
            
            IconScrollView(dataModels: egIconModels, currentDataModel: currentIconModel) { newIconModel in
                currentIconModel = newIconModel
                entity.imageName = newIconModel.egImage
            }
        }
    }
    
    
    var chooseAnimationButton: some View {
        TitleRowView(title: "选择动画", value: entity.symbolEffectType.description, onTapValue: {
            showAnimationSheet.toggle()
        })
    }
    

    var titleEditView: some View {
        VStack(alignment: .center, spacing: 0) {
            TitleRowView(title: "标题")
            
            let textFieldWidth = 320.0
            let textFieldHeight = 40.0
            CJTextSettingRow(
                title: entity.title,
                text: Binding(get: { entity.title }, set: { entity.title = $0 }),
                placeHolder: "请输入内容",
                lineLimit: 1,
                textFieldWidth: textFieldWidth,
                textFieldHeight: textFieldHeight,
                textDidChange: { value in
                    entity.title = value
//                    self.updateUI()
                }
            )
        }
    }
    
    var subTitleEditView: some View {
        VStack(alignment: .center, spacing: 0) {
            TitleRowView(title: "副标题")
            
            let textFieldWidth = 320.0
            let textFieldHeight = 40.0
            CJTextSettingRow(
                title: entity.subTitle,
                text: Binding(get: { entity.subTitle }, set: { entity.subTitle = $0 }),
                placeHolder: "请输入内容",
                lineLimit: 1,
                textFieldWidth: textFieldWidth,
                textFieldHeight: textFieldHeight,
                textDidChange: { value in
                    entity.subTitle = value
//                    self.updateUI()
                }
            )
        }
    }
    
    var addOrUpdateButton: some View {
        Button(hasAdd ? "保存组件" : "添加组件") {
            if let saveId = entity.saveId, saveId.count > 0 {
                TSWidgetBundleCacheUtil.updateControlWidgetEntity(entity, shouldRefreshDesktop: true)
                
                if #available(iOS 18.0, *) {
                    ControlCenter.shared.reloadControls(
                        ofKind: "com.cqWidgetBundleDemo.toggle" //BaseControlWidget.kind
                    )
                } else {
                    // Fallback on earlier versions
                }
            } else {
                entity.saveId = UUID().uuidString
                TSWidgetBundleCacheUtil.addControlWidgetEntity(entity)
            }
            
            
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TitleRowView: View {
    var title: String
    var value: String?
    var onTapValue: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            if let valueString = value {
                HStack(alignment: .center, spacing: 0) {
                    Text(valueString)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                    Text(" >")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    onTapValue?()
                }
            }
        }
    }
}
