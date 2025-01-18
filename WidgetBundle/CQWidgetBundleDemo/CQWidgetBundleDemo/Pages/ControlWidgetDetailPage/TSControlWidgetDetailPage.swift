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
    
    /*
    @Binding var entity: BaseControlWidgetEntity
    // 接收值类型并包装成临时的 Binding
    init(fromPageType: CQPageType, entity: BaseControlWidgetEntity) {
        self.fromPageType = fromPageType
        self._entity = .constant(entity)
    }
    
    // 接收 @State
    init(fromPageType: CQPageType, stateEntity: State<BaseControlWidgetEntity>) {
        self.fromPageType = fromPageType
        self._entity = stateEntity.projectedValue // 使用 projectedValue 获取 Binding
    }
    
    // 接收 @Binding
    init(fromPageType: CQPageType, bindingEntity: Binding<BaseControlWidgetEntity>) {
        self.fromPageType = fromPageType
        self._entity = bindingEntity
    }
    */
    
    
    
    @State var animationType: AnimationType = .none
    @State private var bounce = false   // 是否弹跳
    @State private var swing = false    // 是否摆动
    @State private var rotate = false   // 是否旋转
    @State private var breathe = false  // 是否呼吸
    @State private var pulse = false    // 是否脉冲
    
    @State private var egIconModels: [CJBaseImageModel] = []
    private var symbolEffectTypeOptions: [SymbolEffectType] = [
        .none,
        .bounceUpByLayer,
        .wiggleForwardByLayer,
        .rotateClockwiseByLayer,
        .breathePlainByLayer,
        .pulse
    ]
    private var controlWidgetTypeOptions: [ControlWidgetType] = ControlWidgetType.allCases
    
    @State var currentIconModel: CJBaseImageModel?
    @State var styleSelectedIndex: Int = 0
    @State var animationSelectedIndex: Int = 0
    
    func viewDidLoad() {
        bounce = true
        swing = true
        rotate = true
        breathe = true
        pulse = true
        
        egIconModels = CQControlWidgetExample.iconExamples()
        currentIconModel = egIconModels.first(where: { $0.id == entity.imageModel.id })
        
        styleSelectedIndex = controlWidgetTypeOptions.firstIndex(of: entity.widgetStyle) ?? 0
        animationSelectedIndex = symbolEffectTypeOptions.firstIndex(of: entity.symbolEffectType) ?? 0
        
        getQucikStart() // 获取快捷操作
    }
    
    
    
    func viewOnAppear() {
        print("TSControlWidgetDetailPage onAppear")
    }
    
    private func updateUI() {
        animationType = entity.animateModel.type
    }
    
    
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
            AnimationSheet(options: symbolEffectTypeOptions, selectedIndex: animationSelectedIndex, onChangeOfIndex: { index in
                entity.symbolEffectType = symbolEffectTypeOptions[index]
            }, onCancelBlock: {
                entity.symbolEffectType = symbolEffectTypeOptions[animationSelectedIndex]
                showAnimationSheet = false
            }, onConfirmBlock: { newSelectedIndex in
                animationSelectedIndex = newSelectedIndex
                showAnimationSheet = false
            })
//            .presentationDetents([.medium, .large])
//            .presentationDetents(Set(heights))
            .presentationDetents([.height(400), .height(600)])
            
        }
        .cj_onAppear(viewDidLoad: {
            viewDidLoad()
        }, viewDidAppear: {
            viewOnAppear()
        })
        .task {
            
        }
    }
    let heights = stride(from: 0.1, to: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    
    
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
                options: controlWidgetTypeOptions,
                selectedIndex: $styleSelectedIndex,
                onChangeOfIndex: { index in
                    styleSelectedIndex = index
                    entity.widgetStyle = controlWidgetTypeOptions[index]
                }
            )
            .frame(width: 200)
            
            Spacer().frame(height: 20)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)))
    }
    
    @State var appModel: QuickStartAppModel?
    @State var shortcutsModel: QuickStartShortcutsModel?
    @State var webModel: QuickStartWebModel?
    let quickStartSegmentModels = [
        BaseSegmentModel(segmentId: "0", text: "无操作", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: "1", text: "快捷启动", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: "2", text: "快捷指令", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: "3", text: "自定义", textFontSize: 13, width: 66)
    ]
    @State var defaultSegmentModel: BaseSegmentModel?
    @State var currentSegmentModel: BaseSegmentModel?
    var settingView: some View {
        VStack(alignment: .center, spacing: 0) {
            //            iconChooseView
            
            //            chooseAnimationButton
            //
            titleEditView
            //            subTitleEditView
            
            QuickStartInputView(
                appModel: $appModel,
                shortcutsModel: $shortcutsModel,
                webModel: $webModel,
                options: quickStartSegmentModels,
                currentSegmentModel: $currentSegmentModel,
                onChangeOfExecModel: { newSegmentModel, newAppModel, newShortcutsModel, newWebModel in
                    currentSegmentModel = newSegmentModel
                    appModel = newAppModel
                    shortcutsModel = newShortcutsModel
                    webModel = newWebModel
                }
            )
            
            //            TitleRowView(title: "选择快捷启动", value: "appName", onTapValue: {
            //                //showAnimationSheet.toggle()
            //            })
        }
    }
    
    var iconChooseView: some View {
        VStack(alignment: .center, spacing: 0) {
            TitleRowView(title: "图标", value: "图标库", onTapValue: {
                showAnimationSheet.toggle()
            })
            
            IconScrollView(dataModels: egIconModels, currentDataModel: $currentIconModel) { newIconModel in
                currentIconModel = newIconModel
                entity.imageModel = newIconModel
            }
        }
    }
    
    
    var chooseAnimationButton: some View {
        TitleRowView(title: "选择动画", value: entity.symbolEffectType.description, onTapValue: {
            showAnimationSheet.toggle()
        })
    }
    
    let textFieldHeight = 40.0
    var titleEditView: some View {
        VStack(alignment: .center, spacing: 0) {
            TitleRowView(title: "标题")
            
            CJTextSettingRow(
                title: entity.title,
                text: Binding(get: { entity.title }, set: { entity.title = $0 }),
                placeHolder: "请输入内容",
                lineLimit: 1,
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
            
            CJTextSettingRow(
                title: entity.subTitle,
                text: Binding(get: { entity.subTitle }, set: { entity.subTitle = $0 }),
                placeHolder: "请输入内容",
                lineLimit: 1,
                textFieldHeight: textFieldHeight,
                textDidChange: { value in
                    entity.subTitle = value
                    //                    self.updateUI()
                }
            )
        }
    }
    
    private var hasAdd: Bool {
        var hasAdd: Bool = false
        if let saveId = entity.saveId, saveId.count > 0 {
            hasAdd = true
        }
        return hasAdd
    }
    var addOrUpdateButton: some View {
        Button(hasAdd ? "保存组件" : "添加组件") {
            updateQuickStart() // 更新快捷启动
            
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

extension TSControlWidgetDetailPage {
    private func getQucikStart() {
        appModel = self.entity.appModel
        shortcutsModel = self.entity.shortcutsModel
        webModel = self.entity.webModel
        if let appModel = appModel {
            currentSegmentModel = quickStartSegmentModels[1]
        } else if let shortcutsModel = shortcutsModel {
            currentSegmentModel = quickStartSegmentModels[2]
        } else if let webModel = webModel {
            currentSegmentModel = quickStartSegmentModels[3]
        } else {
            currentSegmentModel = quickStartSegmentModels[0]
        }
        defaultSegmentModel = currentSegmentModel
    }
    
    private func updateQuickStart() {
        let defaultSegmentIndex = quickStartSegmentModels.firstIndex(where: {
            $0.segmentId == defaultSegmentModel?.segmentId
        }) ?? 0
        let currentSegmentIndex = quickStartSegmentModels.firstIndex(where: {
            $0.segmentId == currentSegmentModel?.segmentId
        }) ?? 0
        var lastAppModel: QuickStartAppModel?
        var lastShortcutsModel: QuickStartShortcutsModel?
        var lastWebModel: QuickStartWebModel?
        
        // 判断是否需要变更，如果当前选项下面的值是空的，则使用原值
        var lastUseSegmentIndex = defaultSegmentIndex
        if currentSegmentIndex == 1 && appModel != nil {
            lastUseSegmentIndex = currentSegmentIndex
        } else if currentSegmentIndex == 2 && shortcutsModel != nil {
            lastUseSegmentIndex = currentSegmentIndex
        } else if currentSegmentIndex == 3 && webModel != nil {
            lastUseSegmentIndex = currentSegmentIndex
        } else if currentSegmentIndex == 0 {   // 之前是无操作才能当做无操作，否则不需要变更
            lastUseSegmentIndex = currentSegmentIndex
        }
        
        // 即使最后使用的还是之前的，也得确认之前的选项下的值没被清空，若清空则当做无操作
        if lastUseSegmentIndex == 1 && appModel != nil {
            lastAppModel = appModel
            lastShortcutsModel = nil
            lastWebModel = nil
        } else if lastUseSegmentIndex == 2 && shortcutsModel != nil {
            lastAppModel = nil
            lastShortcutsModel = shortcutsModel
            lastWebModel = nil
        } else if lastUseSegmentIndex == 3 && webModel != nil {
            lastAppModel = nil
            lastShortcutsModel = nil
            lastWebModel = webModel
        } else if lastUseSegmentIndex == 0 {   // 之前是无操作才能当做无操作，否则不需要变更
            lastAppModel = nil
            lastShortcutsModel = nil
            lastWebModel = nil
        }
        self.entity.appModel = lastAppModel
        self.entity.shortcutsModel = lastShortcutsModel
        self.entity.webModel = lastWebModel
    }
}

struct TitleRowView: View {
    var title: String
    @Binding var value: String?
    var onTapValue: (() -> Void)?
    
    init(title: String,
         value: String?,
         onTapValue: (() -> Void)? = nil
    ) {
        self.title = title
        self._value = .constant(value)
        self.onTapValue = onTapValue
    }
    
    init(title: String,
         bindingValue: Binding<String?> = .constant(nil),
         onTapValue: (() -> Void)? = nil
    ) {
        self.title = title
        self._value = bindingValue
        self.onTapValue = onTapValue
    }
    
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
