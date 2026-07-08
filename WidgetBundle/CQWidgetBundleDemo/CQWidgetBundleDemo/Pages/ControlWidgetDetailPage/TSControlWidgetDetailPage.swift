//
//  TSControlWidgetDetailPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import CJViewElement_Swift
import CJAnimationKit_Swift
import WidgetKit
import CJListKit_Swift
import CQWidgetBundle   // 需要使用 ControlWidgetCenterHelpPage
import CQWidgetBundleCommon // 需要引入 ControlWidgetStyle

public class SWToast: NSObject {
    
    public static let shared = SWToast()
    
    
    public static func showText(_ view: UIView? = nil, message: String?,
                                duration: TimeInterval = 2.0,
                                animated: Bool = true,
                                mask: Bool = false) -> Void {
        
    }
    
    public static func hideAll() {
        
    }
    

}

struct TSToastUtil {
    static func showTodo(_ message: String) {
        SWToast.showText(message: "待开发:\(message)")
    }
    
    static func showMessage(_ message: String) {
        SWToast.showText(message: "\(message)")
    }
}

// 控制中心组件数据的状态
// 是否需要下载zip。如果已经有传入完整数据了，那就不用下载
public enum ControlWidgetDataState: String {
    case unknown    // 未知
    case loading    // 加载中
    case successWithNoData  // 加载完成，但后台没有提供数据
    case successPerfect     // 真正的加载完成，有数据
    case failure    // 加载失败
    
    //0 无数据 1 无网络 2 加载中
    func toNoDataType() -> Int {
        switch self {
        case .unknown:
            2
        case .loading:
            2
        case .successWithNoData:
            0
        case .successPerfect:
            4
        case .failure:
            1
        }
    }
}

//0 无数据 1 无网络 2 加载中
func getNoDataType(dataState: ControlWidgetDataState, dataCount: Int) -> Int {
    var noDataType: Int //0 无数据 1 无网络 2 加载中
    if (dataState == .successPerfect) {
        noDataType = 4
    } else if (dataState == .failure) {
        noDataType = 1
    } else if (dataState == .loading) {
        noDataType = 2
    } else {
        if (dataCount == 0) {
            noDataType = 0
        } else {
            noDataType = 2
        }
    }
    return noDataType
}


struct TSControlWidgetDetailPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    var fromPageType: CCPageType
    var isEditing: Bool // 此详情页是否是做编辑使用（如多组件的时候点击保存是返回前一页）
    @State var originalEntitys: [BaseControlWidgetEntity] // 用于恢复(只允许设置一次值）
    @State var originalEntity: BaseControlWidgetEntity // 用于恢复(只允许设置一次值）
    @State var entitys: [BaseControlWidgetEntity]
    @State var entity: BaseControlWidgetEntity
    @State var editingIndex: Int = 0
    
    @State private var showPreviewPage: Bool = false
    @State private var showWidgetStyleTutorial: Bool = false    // 类型切换的帮助
    
    @State private var showAnimationSheet: Bool = false
    @State private var showIconSheet: Bool = false  // 图标库
    @State private var showTextSheet: Bool = false  // 文案库
    @State private var isMoreForCloseState: Bool = false    // 弹出的弹窗是否是给关闭状态使用的
    @State private var isTextForSubTitle: Bool = false    // 弹出的弹窗是否是给子标题使用的
    
    init(fromPageType: CCPageType, setModel: BaseControlWidgetSetModel) {
        self.fromPageType = fromPageType
        self.isEditing = true
        self.dataState = .successPerfect
        
        let entitys = setModel.entitys
        self.originalEntitys = entitys
        self.entitys = entitys
        self.originalEntity = entitys[0]
        self.entity = entitys[0]
        updateEditingIndex(0)
    }
    
    init(fromPageType: CCPageType, entity: BaseControlWidgetEntity) {
        self.fromPageType = fromPageType
        self.isEditing = false
        self.dataState = .successPerfect
        
        let setModel: BaseControlWidgetSetModel = BaseControlWidgetSetModel(
            id: entity.id,
            name: entity.name,
            entitys: [entity]
        )
        let entitys = [entity]
        self.originalEntitys = entitys
        self.entitys = entitys
        self.originalEntity = entitys[0]
        self.entity = entitys[0]
        updateEditingIndex(0)
    }
    
    @State var dataState: ControlWidgetDataState //控制中心组件数据的状态
    var downloadZipModels: [DownloadZipModel]?
    init(fromPageType: CCPageType, previewModel: ControlWidgetPreviewModel) {
        self.fromPageType = fromPageType
        self.isEditing = false
        self.dataState = .loading
        
        if let zipUrl = previewModel.configFile {
            let downloadModel = DownloadZipModel(id: previewModel.id, zipUrl: zipUrl)
            self.downloadZipModels = [downloadModel]
        }
        
        let entitys: [BaseControlWidgetEntity] = [
            BaseControlWidgetEntity.defaultEntityForDesktopType(.toggle),
            BaseControlWidgetEntity.defaultEntityForDesktopType(.quickStart)
        ]
        self.originalEntitys = entitys
        self.entitys = entitys
        self.originalEntity = entitys[0]
        self.entity = entitys[0]
        updateEditingIndex(0)
    }
    
    init(fromPageType: CCPageType, previewModels: ControlWidgetPreviewModels) {
        self.fromPageType = fromPageType
        self.isEditing = true
        self.dataState = .loading
        
        var zipModels: [DownloadZipModel] = []
        for previewModel in previewModels.models {
            if let zipUrl = previewModel.configFile {
                let zipShowId = previewModel.id
                let downloadZipModel = DownloadZipModel(id: zipShowId, zipUrl: zipUrl)
                zipModels.append(downloadZipModel)
            }
        }
        self.downloadZipModels = zipModels
        
        let entitys: [BaseControlWidgetEntity] = [
            BaseControlWidgetEntity.defaultEntityForDesktopType(.toggle),
            BaseControlWidgetEntity.defaultEntityForDesktopType(.quickStart)
        ]
        self.originalEntitys = entitys
        self.entitys = entitys
        self.originalEntity = entitys[0]
        self.entity = entitys[0]
        updateEditingIndex(0)
    }
    
    
    /*
    @Binding var entity: BaseControlWidgetEntity
    // 接收值类型并包装成临时的 Binding
    init(fromPageType: CCPageType, entity: BaseControlWidgetEntity) {
        self.fromPageType = fromPageType
        self._entity = .constant(entity)
    }
    
    // 接收 @State
    init(fromPageType: CCPageType, stateEntity: State<BaseControlWidgetEntity>) {
        self.fromPageType = fromPageType
        self._entity = stateEntity.projectedValue // 使用 projectedValue 获取 Binding
    }
    
    // 接收 @Binding
    init(fromPageType: CCPageType, bindingEntity: Binding<BaseControlWidgetEntity>) {
        self.fromPageType = fromPageType
        self._entity = bindingEntity
    }
    */
    
    
    /*
    @State var animationType: AnimationType = .none
    @State private var bounce = false   // 是否弹跳
    @State private var swing = false    // 是否摆动
    @State private var rotate = false   // 是否旋转
    @State private var breathe = false  // 是否呼吸
    @State private var pulse = false    // 是否脉冲
    */
    private var symbolEffectTypeOptions: [SymbolEffectType] = [
        .none,                       // 无
        .bounceUp,            // 弹跳
        .wiggleClockwise,     // 抖动
        .rotateClockwise,     // 旋转
        .breathePulse,        // 呼吸
        .pulse                       // 脉冲
    ]
    private var controlWidgetTypeOptions: [ControlWidgetStyle] = ControlWidgetStyle.allCases
    
    @State var styleSelectedIndex: Int = 0
    
    func viewDidLoad() {
        /*
        bounce = true
        swing = true
        rotate = true
        breathe = true
        pulse = true
        */
        
        if let zipModels = downloadZipModels {
            downloadZip(zipModels, completeBlock: { isSuccess in
                if isSuccess {
                    self.rememberDefaultData()
                    self.sendEventIfNeed()  // 异步加载完毕后，要上报
                }
            })
        } else {
            self.rememberDefaultData()
        }
    }
    
    private func downloadZip(_ zipModels: [DownloadZipModel], completeBlock: @escaping ((_ isSuccess: Bool)->Void)) {
        /*
        DownloadResourceUtil.downloadJsonZip(
            urlStr: zipUrl,
            success: { (dataModel: BaseControlWidgetEntity) in
                self.entitys = [dataModel]
                self.entity = dataModel
                
            },
            failure: { errorMessage in
                
            }
        )
        */
        
        //var downloadResponseModels = [DownloadResponseModel<BaseControlWidgetEntity>]()
        var downloadResponseModels: [DownloadResponseModel<BaseControlWidgetEntity>?] = Array(repeating: nil, count: zipModels.count)
        let dispatchGroup = DispatchGroup()  // 创建线程组
        let queue = DispatchQueue(label: "com.controlWidget.zip.downloadQueue")  // 自定义的并发队列
        
        for (index, zipModel) in zipModels.enumerated() {
            dispatchGroup.enter()  // 添加一个任务到线程组
            let zipUrl = zipModel.zipUrl
            DownloadResourceUtil.app_downloadJsonZipUrl(zipUrl, isEncryption: true, success: { (dataModel: BaseControlWidgetEntity) in
                debugPrint("组件信息下载成功: \(zipUrl) \n\(dataModel)")
                let downloadResponseModel: DownloadResponseModel<BaseControlWidgetEntity> = DownloadResponseModel(errorMessage: nil, dataModel: dataModel)
                downloadResponseModels[index] = downloadResponseModel  // 使用索引来存储结果    // 下载成功，保存结果
                dispatchGroup.leave()  // 任务完成，离开线程组
                
            }, failure: { errorMessage in
                let downloadResponseModel: DownloadResponseModel<BaseControlWidgetEntity> = DownloadResponseModel(errorMessage: errorMessage, dataModel: nil)
                downloadResponseModels[index] = downloadResponseModel  // 使用索引来存储结果    // 下载失败，返回错误
                dispatchGroup.leave()  // 即使失败也要离开线程组
            })
        }
        
        // 在所有下载任务完成后执行
        dispatchGroup.notify(queue: queue) {
            let needDownloadCount = zipModels.count
            let realDownloadCount = downloadResponseModels.count
            guard realDownloadCount == needDownloadCount else {
                return
            }
            
            var downloadEntitys = [BaseControlWidgetEntity]()
            var allErrorMessage: String?
            for i in 0..<realDownloadCount {
                let downloadResponseModel = downloadResponseModels[i]
                if var dataModel = downloadResponseModel?.dataModel {
                    dataModel.widgetId = zipModels[i].id    // 组件id使用外部的，同一个组件显示在不同地方会有不同id
                    downloadEntitys.append(dataModel)
                } else {
                    let errorMessage: String = downloadResponseModel?.errorMessage ?? ""
                    if allErrorMessage == nil {
                        allErrorMessage = ""
                    }
                    allErrorMessage! += errorMessage
                }
            }
            
            self.originalEntitys = downloadEntitys
            self.entitys = downloadEntitys
            
            // 主线程
            DispatchQueue.main.async {
                if allErrorMessage == nil, downloadEntitys.count > 0 {
                    updateEditingIndex(0)
                    self.dataState = .successPerfect
                    completeBlock(true)
                } else {
                    self.dataState = .failure
                    //if let allErrorMessage = allErrorMessage {
                    //    TSToastUtil.showMessage(allErrorMessage)
                    //}
                    completeBlock(false)
                }
            }
        }
   }
    
    private func rememberDefaultData() {
        styleSelectedIndex = controlWidgetTypeOptions.firstIndex(of: entity.widgetStyle) ?? 0
        
        //TODO: qian
        shakeMusicModel = ShakeMusicModel()
        shakeMusicModel?.audioInfoModels = [AudioInfoModel()]
    }
    
    
    
    func viewOnAppear() {
        print("TSControlWidgetDetailPage onAppear")
    }
    
    private func updateUI() {
        //animationType = entity.animateModel.type
    }
    
    
    @State var scrollViewProxy: ScrollViewProxy?
    let horizontalPadding: CGFloat = 20.0
    
    var body: some View {
        bodyContent
            .navigationBarBackButtonHidden(true)
        .onChange(of: entity) { _ in
            updateEntitys()
        }
    }
    
    private func updateEntitys() {
        // 使用.onChange(of: entity) { _ in } 避免每次entity中的属性变化都要手动同步更新 entitys
        let oldEditId = self.entity.id
        let oldEditIndex = self.entitys.firstIndex(where: { $0.id == oldEditId }) ?? 0
        self.entitys[oldEditIndex] = self.entity
    }
    
    @State private var hasAppeared = false
    @State private var isDisappeared = true
    @Environment(\.scenePhase) private var scenePhase
    func sendEventIfNeed() {
        if dataState == .successPerfect {
            CCControlWidgetEventUtil.browse(outId: self.entity.widgetId)
        }
    }
    
    var bodyContent: some View {
        ZStack(alignment: .top){
            // 自定义的导航视图
            contentView
                .padding(
                    EdgeInsets(
                        top: UIDevice.xp_navigationFullHeight(),
                        leading: 0,
                        bottom: UIDevice.xp_safeDistanceBottom(),
                        trailing: 0
                    )
                )
                //.onFirstAppear() {
                .onAppear() {
                    if !hasAppeared {
                        hasAppeared = true
                        self.viewDidLoad()
                    }
                    sendEventIfNeed()
                }
                .onDisappear {
                    isDisappeared = true
                }
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        sendEventIfNeed()
                    case .background:
                        isDisappeared = true
                    default:
                        debugPrint("")
                    }
                }
            
//            navigationBar
            let title = "\(entity.name)"
            NavigationBarView(
                title: title,
                titleViewIsLeft: false,
                hideBackBtn: false,
                rightButtonContent: {
                    if dataState == .successPerfect {
                        Text("预览")
                            .foregroundColor(Color(hex: "#333333"))
                            .font(.system(size: 15, weight: .regular))
                            .frame(width: 28+2*21, height: 15)
                            .onTapGesture {
                                self.dismissKeyboard()
                                self.showPreviewPage.toggle()
                            }
                    } else {
                        EmptyView()
                    }
                },
                leftComplete: {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .background(Color(hex: "#F5F5F5"))
            
            if showAnimationSheet {
                BaseSheetPage(
                    isShowing: $showAnimationSheet,
                    hideTopLine: true,
                    toolBottomToContentTop: 0.0,
                    title: "选择动画",
                    onCancelBlock: {
                        let animationSelectedIndex = self.symbolEffectTypeOptions.firstIndex(of: self.symbolEffectTypeBeforeChoose) ?? 0
                        self.entity.symbolEffectType = self.symbolEffectTypeOptions[animationSelectedIndex]
                        self.showAnimationSheet = false
                    },
                    onConfirmBlock: {
//                        let animationSelectedIndex = self.symbolEffectTypeOptions.firstIndex(of: self.entity.symbolEffectType) ?? 0
//                        self.entity.symbolEffectType = self.symbolEffectTypeOptions[animationSelectedIndex]
                        self.symbolEffectTypeBeforeChoose = self.entity.symbolEffectType
                        
                        self.showAnimationSheet = false
                        self.entity.isOffInDetailPage = false
                    },
                    contentHeight: 216,
                    content: {
                        let animationSelectedIndex = self.symbolEffectTypeOptions.firstIndex(of: self.entity.symbolEffectType) ?? 0
                        AnimationSheetView(options: symbolEffectTypeOptions, selectedIndex: animationSelectedIndex, onChangeOfIndex: { index in
                            self.entity.symbolEffectType = self.symbolEffectTypeOptions[index]
                            self.entity.isOffInDetailPage = false
                        })
                        /*
                        VStack {
                            Text("好")
                                .foregroundColor(Color.pink)
                                .background(Color.yellow)
                                .frame(height: 100)
                        }
                        .background(Color.blue)
                        .frame(height: 266)
                        */
                    }
                )
            }
            
            if showIconSheet {
                BaseSheetPage(
                    isShowing: $showIconSheet,
                    hideTopLine: false,
                    toolBottomToContentTop: 21.0,
                    contentHeight: 529,
                    content: {
                        IconLinkedMenuViewRepresentable(
                            rightColumnCount: 4,
                            layoutModel: CJLinkedMenuLayoutModel(
                                sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 17.0, right: 0),
                                rightHeaderHeight: 0,
                                rightCellWidthHeightRatio: 1.0,
                                minimumLineSpacing: 17.0,
                                minimumInteritemSpacing: 17.0
                            ),
                            isForCloseState: $isMoreForCloseState,
                            alwaysDisableTintColor: self.entity.alwaysDisableTintColor,
                            selectedImageName: isMoreForCloseState ? (entity.offModel?.imageModel.imageName ?? "") : entity.onModel.imageModel.imageName,
                            onTapRightIndexPath: { _, newImageModel in
//                                showIconSheet = false
                                self.updateNewIconModel(newImageModel, for: self.isMoreForCloseState, needReport: true)
                            },
                            requestDataHandler: self.requestIconData
                        )
//                        IconSheetView(
//                            options: [IconModuleModel(name: "可爱", options: egIconModels)],
//                            selectedIndex: animationSelectedIndex,
//                            onChangeOfIndex: { index in
//                                //entity.symbolEffectType = symbolEffectTypeOptions[index]
//                                showIconSheet = false
//                            }
//                        )
                    }
                )
            }
            
            if showTextSheet {
                BaseSheetPage(
                    isShowing: $showTextSheet,
                    hideTopLine: false,
                    toolBottomToContentTop: 21.0,
                    contentHeight: 529,
                    content: {
                        TextLinkedMenuViewRepresentable(
                            rightColumnCount: 1,
                            layoutModel: CJLinkedMenuLayoutModel(
                                sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                rightHeaderHeight: 45.0,
                                rightCellWidthHeightRatio: 273.0/45.0,
                                minimumLineSpacing: 10.0,
                                minimumInteritemSpacing: 10.0
                            ),
                            isForCloseState: $isMoreForCloseState,
                            selectedText: getCurrentSelectedText(),
                            onTapRightIndexPath: { _, newTextModel in
                                CCControlWidgetEventUtil.clickTextId(outId: newTextModel.id)
                                
//                                showTextSheet = false
                                self.entity.isOffInDetailPage = self.isMoreForCloseState
                                if self.isTextForSubTitle {
                                    if self.isMoreForCloseState {
                                        self.entity.offModel?.subTitle = newTextModel.text
                                    } else {
                                        self.entity.onModel.subTitle = newTextModel.text
                                    }
                                } else {
                                    if self.isMoreForCloseState {
                                        self.entity.offModel?.title = newTextModel.text
                                    } else {
                                        self.entity.onModel.title = newTextModel.text
                                    }
                                }
                            },
                            requestDataHandler: self.requestTextData
                        )
//                        TextSheetView(options: symbolEffectTypeOptions, selectedIndex: animationSelectedIndex, onChangeOfIndex: { index in
//                            //entity.symbolEffectType = symbolEffectTypeOptions[index]
//                            showTextSheet = false
//                        })
                    }
                )
            }
            
            if showWidgetStyleTutorial {
                ControlWidgetCenterHelpPage(
                    contentHeight: 320-20-40-20,
                    isShowing: $showWidgetStyleTutorial,
                    doneTitle: "我知道了",
                    dataArray: [
                        TutorialsItem(title: "", subTitle: "", fileName: "controlwidget_style_transparent"),
                    ]
                )
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showPreviewPage) {
            ControlWidgetPreviewPage(entity: self.$entity)
                .onTapGesture {
                    self.showPreviewPage.toggle()
                }
        }
//        .adjustForKeyboard()
    }
    // 获取更多文案库中药选中的文案
    private func getCurrentSelectedText() -> String {
        var selectedText: String
        if isTextForSubTitle {
            if isMoreForCloseState {
                selectedText = entity.offModel?.subTitle ?? ""
            } else {
                selectedText = entity.onModel.subTitle
            }
        } else {
            if isMoreForCloseState {
                selectedText = entity.offModel?.title ?? ""
            } else {
                selectedText = entity.onModel.title
            }
        }
        return selectedText
    }
    
    @ViewBuilder
    var contentView: some View {
        if dataState == .successPerfect {
            successContentView
        } else {
            VStack(alignment: .center, spacing: 0) {
//                PageStateView(pageState: .constant(dataState == .failure ? .error : .loading), reloadHandler: {
//                    if let zipModels = downloadZipModels {
//                        downloadZip(zipModels, completeBlock: { isSuccess in
//                            if isSuccess {
//                                self.rememberDefaultData()
//                            }
//                        })
//                    }
//                })
                //Text("加载中...")
                Spacer()
            }
        }
    }
    
    var successContentView: some View {
        VStack(alignment: .center, spacing: 0) {
            headerView
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical) {
                    self.settingView(
                        geoWidth: UIScreen.main.bounds.width - 2 * self.horizontalPadding,
                        scrollViewProxy: scrollViewProxy
                    )
                    .padding(.horizontal, self.horizontalPadding)
//                        .padding(.bottom, 50.0) // 额外增加点底部距离，避免滑动结束后尾部刚和和其他视图顶部贴住
                    .padding(.bottom, max(50.0, self.keyboardObserver.keyboardHeight-40)) // 添加底部填充距离
                    .animation(.easeOut(duration: 0.3), value: self.keyboardObserver.keyboardHeight)
                }
            }
            
            addOrUpdateButton
            
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        /*
        .sheet(isPresented: $showAnimationSheet) {
            animationSheet
        }
        */
    }
//    let heights = stride(from: 0.1, to: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    /*
    var animationSheet: some View {
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
//            .presentationDetents([.height(400), .height(600)])
    }
    */
    var headerView: some View {
        let widgetSize = entity.widgetStyle.designSizeInApp
        return VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 17)
            
            //List {
                VStack(alignment: .center, spacing: 0) {
                    // 内部会根据 entity.isOffInDetailPage 来判断显示
                    BaseControlWidgetViewInApp(bindingEntity: $entity, pageInfo: CCPageInfo(pageType: .controlWidgetDetailPage))
                        .frame(width: widgetSize.width, height: widgetSize.height)
                }
                .frame(height: 139)
            //}

            Spacer().frame(height: 17)
            
            StyleSegmentedView(
                options: controlWidgetTypeOptions,
                selectedIndex: $styleSelectedIndex,
                onChangeOfIndex: { index in
                    self.styleSelectedIndex = index
                    self.entity.widgetStyle = self.controlWidgetTypeOptions[index]
                   
                    // 更新每个 Entity 的 widgetStyle 状态
                    let newWidgetStyle = self.controlWidgetTypeOptions[index]
                    for index in entitys.indices {
                        entitys[index].widgetStyle =  newWidgetStyle
                    }
                },
                onTapHelp: {
                    self.dismissKeyboard()
                    self.showWidgetStyleTutorial.toggle()
                }
            )
            .frame(width: 146+35*2)
            //.background(Color.red)
            
            Spacer().frame(height: 20)
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)))
    }
    
    // 快捷执行的临时变量，最终只会取一个，不会都设置进 entity 中
    let quickStartSegmentModels = [
        //BaseSegmentModel(segmentId: QuickStartType.none.rawValue, text: "无操作", textFontSize: 13, width: 66),
        BaseSegmentModel(segmentId: QuickStartType.app.rawValue, text: "快捷启动", textFontSize: 10.5, width: 66),
        BaseSegmentModel(segmentId: QuickStartType.shortcuts.rawValue, text: "快捷指令", textFontSize: 10.5, width: 66),
        //BaseSegmentModel(segmentId: QuickStartType.web.rawValue, text: "自定义", textFontSize: 13, width: 66)
    ]
    
    @State var shakeMusicModel: ShakeMusicModel? = nil
    func settingView(geoWidth: CGFloat, scrollViewProxy: ScrollViewProxy) -> some View {
        VStack(alignment: .center, spacing: 0) {
            settingStateView(forCloseState: false)
                .padding(.top, titlePaddingTop)
            
            if exsitCloseState {
                settingStateView(forCloseState: true)
                    .padding(.top, titlePaddingTop)
            }
            
            if entity.quickStartEnable == true {
                
                let bindingValue = Binding<BaseSegmentModel?>(
                    get: {
                        let currentSegmentModel = getQuickStartSegmentModelForEntity(self.entity)
                        return currentSegmentModel
                    },
                    set: { newSegmentModel in
                        var editingQuickStartType: QuickStartType?
                        if let newSegmentId = newSegmentModel?.segmentId {
                            editingQuickStartType = QuickStartType(rawValue: newSegmentId)
                        }
                        if editingQuickStartType == nil {
                            if let firstSegmentId = quickStartSegmentModels.first?.segmentId {
                                editingQuickStartType = QuickStartType(rawValue: firstSegmentId)
                            }
                        }
                        self.entity.onModel.editingQuickStartType = editingQuickStartType ?? .none
                    }
                )
                QuickStartInputView(
                    geoWidth: geoWidth,
                    appModel: self.$entity.onModel.appModel,
                    shortcutsModel: self.$entity.onModel.shortcutsModel,
                    webModel: self.$entity.onModel.webModel,
                    options: quickStartSegmentModels,
                    currentSegmentModel: bindingValue,
                    onChangeOfExecModel: { newSegmentModel, newAppModel, newShortcutsModel, newWebModel in
//                        self.currentSegmentModel = newSegmentModel
                        //self.entity.onModel.editingQuickStartType = xxx //在 bindingValue 的 set 中设置,不然newSegmentModel错误
                        
                        self.entity.onModel.appModel = newAppModel
                        self.entity.onModel.shortcutsModel = newShortcutsModel
                        self.entity.onModel.webModel = newWebModel
                    }
                )
                .padding(.top, titlePaddingTop)
            }
            
            if entity.playSoundEnable == true {
                if let shakeMusicModel = shakeMusicModel {
                    ControlWidgetAudioSettingView(
                        //                viewModel: viewModel,
                        model: shakeMusicModel,
                        scroller: scrollViewProxy,
                        //                scrollerId: scrollerId,
                        haveAudio: shakeMusicModel.haveAudio,
                        notificationType: shakeMusicModel.notificationType,
                        selectAudio: shakeMusicModel.selectAudio
                    )
                    .environmentObject(audioEditStatus)
                    .padding(.top, titlePaddingTop)
                }
            }
        }
    }
    @State var audioEditStatus: EditStatusModel = EditStatusModel()
    
    private let titlePaddingTop: CGFloat = 25.0
    private let contentToTitleDistance: CGFloat = 15.0
    
    func settingStateView(forCloseState: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            if self.entitys.count > 1, forCloseState == false {
                widgetChooseView(forCloseState: forCloseState)
                    .padding(.bottom, titlePaddingTop)
            }
            
            iconChooseView(forCloseState: forCloseState)
            
            if !forCloseState {
                iconColorChooseView
                    .padding(.top, titlePaddingTop)
                
                if allowAnimation {
                    chooseAnimationButton
                        .padding(.top, titlePaddingTop)
                }
            }
            
            titleEditView(forCloseState: forCloseState)
                .padding(.top, titlePaddingTop)
            subTitleEditView(forCloseState: forCloseState)
                .padding(.top, contentToTitleDistance)
        }
    }
    
    func fixCircleEntitys() -> [BaseControlWidgetEntity] {
        var fixCircleEntitys = self.entitys // 固定是圆形的数据
        for index in fixCircleEntitys.indices {
            fixCircleEntitys[index].widgetStyle =  .circle
        }
        return fixCircleEntitys
    }
    
    func widgetChooseView(forCloseState: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            ControlWidgetTitleRowView(
                title: "包含控制项",
                showRecover: .constant(false),
                onTapRecover: nil,
                value: nil,
                onTapValue: nil
            )
            
            let bindingValue2 = Binding<BaseControlWidgetEntity?>(
                get: {
//                    if forCloseState {
//                        entity.offModel?.imageModel
//                    } else {
//                        entity.onModel.imageModel
//                    }
                    self.entity.copyWithNewWidgetStyle(.circle)
                },
                set: {
                    self.entity = $0!
//                    entity.isOffInDetailPage = forCloseState
                }
            )
            
            ControlWidgetScrollView(
                dataModels: fixCircleEntitys(),
                currentDataModel: bindingValue2,
                enableTintColor: .constant(!forCloseState),
                onChangeOfDataModel: { newDataModel in
                    self.dismissKeyboard()
                    
                    // 先保存旧修改
                    let oldEditId = self.entity.id
                    let oldEditIndex = self.entitys.firstIndex(where: { $0.id == oldEditId }) ?? 0
                    self.entitys[oldEditIndex] = self.entity
                    
                    // 切换到新选项
                    let selectedIndex = self.entitys.firstIndex(where: { $0.id == newDataModel.id })
                    self.updateEditingIndex(selectedIndex ?? 0)
//                    updateNewIconModel(newIconModel, for: forCloseState)
                    
                    sendEventIfNeed()
                }
            )
            .padding(.top, contentToTitleDistance)
        }
    }
    
    func updateEditingIndex(_ selectedIndex: Int) {
        self.editingIndex = selectedIndex
        self.originalEntity = self.originalEntitys[selectedIndex]
        self.entity = self.entitys[selectedIndex]
    }
    
    func iconChooseView(forCloseState: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            let bindingValue = Binding<Bool>(
                get: {
                    if forCloseState {
                        self.entity.offModel?.imageModel.id != self.originalEntity.offModel?.imageModel.id
                    } else {
                        self.entity.onModel.imageModel.id != self.originalEntity.onModel.imageModel.id
                    }
                },
                set: { newValue in
                    
                }
            )
            let title = exsitCloseState ? "\(forCloseState ? "关闭状态图标" : "开启状态图标")" : "图标"
            ControlWidgetTitleRowView(
                title: title,
                showRecover: bindingValue,
                onTapRecover: {
                    self.dismissKeyboard()
                    self.recoverIconModel(for: forCloseState)
                },
                value: "图标库",
                onTapValue: {
                    self.dismissKeyboard()
                    self.showIconSheet.toggle()
                    self.isMoreForCloseState = forCloseState
                }
            )
            
            let bindingValue2 = Binding<CJBaseImageModel?>(
                get: {
                    if forCloseState {
                        self.entity.offModel?.imageModel
                    } else {
                        self.entity.onModel.imageModel
                    }
                },
                set: {
                    if forCloseState {
                        self.entity.offModel?.imageModel = $0!
                    } else {
                        self.entity.onModel.imageModel = $0!
                    }
                }
            )
            let enableTintColor = (forCloseState == true || self.entity.alwaysDisableTintColor == true) ? false : true
            IconScrollView(
                currentDataModel: bindingValue2,
                enableTintColor: .constant(enableTintColor),
                onChangeOfDataModel: { newIconModel in
                    self.dismissKeyboard()
                    self.updateNewIconModel(newIconModel, for: forCloseState, needReport: false)
                },
                onTapMore: {
                    self.dismissKeyboard()
                    self.showIconSheet.toggle()
                    self.isMoreForCloseState = forCloseState
                },
                requestDataHandler: self.requestScrollIconData
            )
            .padding(.top, contentToTitleDistance)
        }
    }
    
    private func updateNewIconModel(_ newIconModel: CJBaseImageModel, for forCloseState: Bool, needReport: Bool) {
        if forCloseState {
            entity.offModel?.imageModel = newIconModel
        } else {
            entity.onModel.imageModel = newIconModel
        }
        
        //【【IOS18控制中心】图标打开状态下选中后，自动选中对应的关闭状态的图。暂时不做开启/关闭图标选择的区分了。】 https://www.tapd.cn/tapd_fe/66656887/bug/detail/1166656887001001604
        if forCloseState {
            entity.onModel.imageModel = newIconModel.copyWithColorString(entity.onModel.imageModel.imageColorString) // 不能去除颜色
        } else {
            entity.offModel?.imageModel = newIconModel.copyWithColorString(nil)
        }
        
        
        entity.isOffInDetailPage = forCloseState
        
        // 热门推荐的图标不用上报
        if (needReport) {
            CCControlWidgetEventUtil.clickSymbolIconId(outId: newIconModel.id)
        }
    }
    
    private func recoverIconModel(for forCloseState: Bool) {
//        【【IOS18控制中心】图标打开状态下选中后，自动选中对应的关闭状态的图。暂时不做开启/关闭图标选择的区分了。】
//        https://www.tapd.cn/tapd_fe/66656887/bug/detail/1166656887001001604
        //if forCloseState {
            if self.originalEntity.offModel?.imageModel != nil {
                self.entity.offModel?.imageModel = self.originalEntity.offModel!.imageModel
            }
        //} else {
            if self.originalEntity.onModel.imageModel != nil {
                self.entity.onModel.imageModel = self.originalEntity.onModel.imageModel
            }
        //}
        
        self.entity.isOffInDetailPage = forCloseState
    }
    
    
    var iconColorChooseView: some View {
//        Text("图标颜色")
        
        let title = exsitCloseState ? "开启图标颜色" : "图标颜色"
        let subTitle = entity.quickStartEnable == true ? "（点击时显示）" : nil
        let bindingValue = Binding<CJBoxDecorationModel>(
            get: {
                var colorModel: CJTextColorDataModel
                if let imageColorModel = self.entity.onModel.imageColorModel {
                    colorModel = CJTextColorDataModel(solidColorString: imageColorModel.colorString)
                } else {
                    colorModel = CJTextColorDataModel()
                }
                return CJBoxDecorationModel(colorModel: colorModel)
            },
            set: { newBackgroundModel in
                let newColorModel = newBackgroundModel.colorModel
                if let colorString = newColorModel?.colorStrings.first {
                    self.entity.onModel.imageColorModel = IconColorModel(colorString: colorString)
                } else {
                    self.entity.onModel.imageColorModel = nil
                }
            }
        )
        
        return CJBackgroundSettingRow(
            title: title,
            subTitle: subTitle,
            models: TSRowDataUtil.backgroundColorData(),
            currentBackgroundModel: bindingValue,
            onChangeOfBackgroundModel: { newBackgroundModel in
                self.dismissKeyboard()
                
                let newColorModel = newBackgroundModel.colorModel
                if let colorString = newColorModel?.colorStrings.first {
                    self.entity.onModel.imageColorModel = IconColorModel(colorString: colorString)
                } else {
                    self.entity.onModel.imageColorModel = nil
                }
                self.entity.isOffInDetailPage = false
            }
        )
        //.background(Color.orange.opacity(0.3))
        //*/
    }
    
    @State var symbolEffectTypeBeforeChoose: SymbolEffectType = .none   // 记录进行动画选择前的选中动画类型（用于点击取消的时候恢复）
    var chooseAnimationButton: some View {
        ControlWidgetTitleRowView(title: "选择动画", value: entity.symbolEffectType.description, onTapValue: {
            self.dismissKeyboard()
            
            self.symbolEffectTypeBeforeChoose = self.entity.symbolEffectType    // 记录
            self.showAnimationSheet.toggle()
        })
    }
    
    
    
    let textFieldHeight = 40.0
    func titleEditView(forCloseState: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            let title = exsitCloseState ? "\(forCloseState ? "关闭状态标题" : "开启状态标题")" : "标题"
            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .foregroundColor(Color(hex: "#333333"))
                    .font(.system(size: 15.5, weight: .medium))
                Text("（最小尺寸中不显示）")
                    .foregroundColor(Color(hex: "#999999"))
                    .font(.system(size: 13.5, weight: .regular))
                Spacer()
            }
            
            CJTextInputView(
                text: Binding(
                    get: {
                        forCloseState ? (self.entity.offModel?.title ?? "") : self.entity.onModel.title
                    },
                    set: {
                        if forCloseState {
                            self.entity.offModel?.title = $0
                        } else {
                            self.entity.onModel.title = $0
                        }
                    }
                ),
                placeHolder: "请输入内容",
                lineLimit: 1,
                textDidChange: { value in
                    if forCloseState {
                        self.entity.offModel?.title = value
                    } else {
                        self.entity.onModel.title = value
                    }
                    self.entity.isOffInDetailPage = forCloseState
                    //                    self.updateUI()
                }
            )
            .withLevelTwoTailingTitle("文案库", titleWidth: 42, onTapTitle: {
                self.dismissKeyboard()
                self.showTextSheet.toggle()
                self.isMoreForCloseState = forCloseState
                self.isTextForSubTitle = false
            })
            .withCornerRadius(7.5, horizontalPadding: 10)
            .frame(height: self.textFieldHeight)
            .padding(.top, self.contentToTitleDistance)
        }
    }
    
    func subTitleEditView(forCloseState: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            //ControlWidgetTitleRowView(title: "副标题")
            
            CJTextInputView(
                text: Binding(
                    get: {
                        forCloseState ? (self.entity.offModel?.subTitle ?? "") : self.entity.onModel.subTitle
                    },
                    set: {
                        if forCloseState {
                            self.entity.offModel?.subTitle = $0
                        } else {
                            self.entity.onModel.subTitle = $0
                        }
                    }
                ),
                placeHolder: "请输入内容",
                lineLimit: 1,
                textDidChange: { value in
                    if forCloseState {
                        self.entity.offModel?.subTitle = value
                    } else {
                        self.entity.onModel.subTitle = value
                    }
                    self.entity.isOffInDetailPage = forCloseState
                    //                    self.updateUI()
                }
            )
            .withLevelTwoTailingTitle("文案库", titleWidth: 42, onTapTitle: {
                self.dismissKeyboard()
                self.showTextSheet.toggle()
                self.isMoreForCloseState = forCloseState
                self.isTextForSubTitle = true
            })
            .withCornerRadius(7.5, horizontalPadding: 10)
            .frame(height: self.textFieldHeight)
            //.padding(.top, contentToTitleDistance)
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
        Button(
            action: {
                
                
                self.updateQuickStart() // 更新快捷启动
                
                if self.isEditing { // 是多组件的编辑页
                    //TODO: qian 多组件的保存
                    // 发送通知
                    NotificationCenter.default.post(name: .entitysModified, object: entitys)
                } else {
                    self.entity = self.entitys[self.editingIndex] // 修复单个快捷启动操作时候没有更新 self.entity
                    self.entity.isOffInDetailPage = false // 即使是在关闭状态时候进行的添加或者更新到我的组件，重新在详情里显示时候都应该以打开显示
                    
                    if let saveId = self.entity.saveId, saveId.count > 0 {
                        TSWidgetBundleCacheUtil.updateControlWidgetEntity(self.entity, shouldRefreshDesktop: true)
//                        WIToastView.showView(hintType: .success, hintStr: "保存成功")
                        CCControlWidgetEventUtil.save(outId: self.entity.widgetId)
                        
                    } else {
                        TSWidgetBundleCacheUtil.addControlWidgetEntity(self.entity)
//                        WIToastView.showView(hintType: .success, hintStr: "成功添加至【我的组件】")
                        CCControlWidgetEventUtil.save(outId: self.entity.widgetId)
                        
                        if(UserDefaults.standard.object(forKey: "firstAddControlWidget") == nil) {
                            UserDefaults.standard.setValue(true, forKey: "firstAddControlWidget")
                            //NotificationCenter.default.post(name: Notification.Name("kNoti_showTutorial_AddControlWidget"), object: nil)
                        }
                    }
                }
                
                self.presentationMode.wrappedValue.dismiss()
            },
            label: {
                Text(isEditing ? "保存编辑" : (hasAdd ? "保存控制项" : "添加控制项"))
                    .font(.system(size: 15.5, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 确保label填充整个按钮区域，避免点击区域只有文字部分
            }
        )
        .frame(width: 270, height: 48)
        .background(Color(hex: "#2E2E2E")) // 设置按钮背景色
        .cornerRadius(24) // 设置按钮圆角
    }
    
    //MARK: 判断是否存在某个选项
    /// 是否是有开关状态的组件
    private var exsitCloseState: Bool {
        return entity.offModel != nil
    }
    
    private var allowAnimation: Bool {
        return entity.quickStartEnable != true
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension TSControlWidgetDetailPage {
    private func getQuickStartSegmentModelForEntity(_ entity: BaseControlWidgetEntity) -> BaseSegmentModel? {
        let quickStartType: QuickStartType = entity.onModel.editingQuickStartType
                
        if let segmentModel = quickStartSegmentModels.first(where: { $0.segmentId == quickStartType.rawValue }) {
            return segmentModel
        } else {     // 本应选中的快捷方式在提供的选项中未找到时候，默认选中第一项
            return quickStartSegmentModels.first
        }
    }
    
    private func updateQuickStart() {
//        var newEntitys: [BaseControlWidgetEntity] = []
        for index in self.entitys.indices {
            var iEntity = self.entitys[index]

            let defaultSegmentType: QuickStartType = self.originalEntitys[index].onModel.editingQuickStartType
            self.getLastQuickStartForEntity(&iEntity, defaultSegmentType: defaultSegmentType)
            
//            print("After modification: \(iEntity)")
//            newEntitys.append(iEntity)
            self.entitys[index] = iEntity
//            print("Entitys after update: \(self.entitys[index])")
        }
//        self.entitys = newEntitys
        
        /*
        let defaultSegmentType: QuickStartType = QuickStartType(rawValue: defaultSegmentModel?.segmentId ?? "") ?? .none
        let currentSegmentType: QuickStartType = QuickStartType(rawValue: currentSegmentModel?.segmentId ?? "") ?? .none

        var lastAppModel: QuickStartAppModel?
        var lastShortcutsModel: QuickStartShortcutsModel?
        var lastWebModel: QuickStartWebModel?
        
        // 判断是否需要变更，如果当前选项下面的值是空的，则使用原值
        let onoffModel = self.entity.onModel
        let appModel = onoffModel.appModel
        let shortcutsModel = onoffModel.shortcutsModel
        let webModel = onoffModel.webModel
        var lastUseSegmentType = defaultSegmentType
        if currentSegmentType == .app && appModel != nil {
            lastUseSegmentType = currentSegmentType
        } else if currentSegmentType == .shortcuts && shortcutsModel != nil {
            lastUseSegmentType = currentSegmentType
        } else if currentSegmentType == .web && webModel != nil {
            lastUseSegmentType = currentSegmentType
        } else if currentSegmentType == .none {   // 之前是无操作才能当做无操作，否则不需要变更
            lastUseSegmentType = currentSegmentType
        }
        
        // 即使最后使用的还是之前的，也得确认之前的选项下的值没被清空，若清空则当做无操作
        if lastUseSegmentType == .app && appModel != nil {
            lastAppModel = appModel
            lastShortcutsModel = nil
            lastWebModel = nil
        } else if lastUseSegmentType == .shortcuts && shortcutsModel != nil {
            lastAppModel = nil
            lastShortcutsModel = shortcutsModel
            lastWebModel = nil
        } else if lastUseSegmentType == .web && webModel != nil {
            lastAppModel = nil
            lastShortcutsModel = nil
            lastWebModel = webModel
        } else if lastUseSegmentType == .none {   // 之前是无操作才能当做无操作，否则不需要变更
            lastAppModel = nil
            lastShortcutsModel = nil
            lastWebModel = nil
        }
        onoffModel.appModel = lastAppModel
        onoffModel.shortcutsModel = lastShortcutsModel
        onoffModel.webModel = lastWebModel
        */
    }
    
    private func getLastQuickStartForEntity(_ tEntity: inout BaseControlWidgetEntity, defaultSegmentType: QuickStartType) {
        if tEntity.quickStartEnable != true {
            return
        }
        
        let currentSegmentType: QuickStartType = tEntity.onModel.editingQuickStartType
        
        // 判断是否需要变更，如果当前选项下面的值是空的，则使用原值
        let onoffModel = tEntity.onModel
        let appModel = onoffModel.appModel
        let shortcutsModel = onoffModel.shortcutsModel
        let webModel = onoffModel.webModel
        var lastUseSegmentType = defaultSegmentType
        if currentSegmentType == .app && appModel != nil {
            lastUseSegmentType = currentSegmentType
        } else if currentSegmentType == .shortcuts && shortcutsModel != nil {
            lastUseSegmentType = currentSegmentType
        } else if currentSegmentType == .web && webModel != nil {
            lastUseSegmentType = currentSegmentType
        } else if currentSegmentType == .none {   // 之前是无操作才能当做无操作，否则不需要变更
            lastUseSegmentType = currentSegmentType
        }
        
        var lastAppModel: QuickStartAppModel?
        var lastShortcutsModel: QuickStartShortcutsModel?
        var lastWebModel: QuickStartWebModel?
        // 即使最后使用的还是之前的，也得确认之前的选项下的值没被清空，若清空则当做无操作
        if lastUseSegmentType == .app && appModel != nil {
            lastAppModel = appModel
            lastShortcutsModel = nil
            lastWebModel = nil
        } else if lastUseSegmentType == .shortcuts && shortcutsModel != nil {
            lastAppModel = nil
            lastShortcutsModel = shortcutsModel
            lastWebModel = nil
        } else if lastUseSegmentType == .web && webModel != nil {
            lastAppModel = nil
            lastShortcutsModel = nil
            lastWebModel = webModel
        } else if lastUseSegmentType == .none {   // 之前是无操作才能当做无操作，否则不需要变更
            lastAppModel = nil
            lastShortcutsModel = nil
            lastWebModel = nil
        }
        
        tEntity.onModel.appModel = lastAppModel
        tEntity.onModel.shortcutsModel = lastShortcutsModel
        tEntity.onModel.webModel = lastWebModel
    }
}

extension TSControlWidgetDetailPage {
    func requestScrollIconData(success: @escaping ([CJBaseImageModel]) -> Void, failure: @escaping (Error) -> Void) {
        
        // 1秒后执行 //TODO: qian
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sectionDataModels: [IconLinkMenuSectionModel] = IconLinkMenuSectionModel.iconSectionExamples()
            let recommendIconModels: [CJBaseImageModel] = sectionDataModels.first?.values ?? []
            success(recommendIconModels)

        }
        
//        CCRequestUtil.requestControlWidgetDatas(
//            API.ctrIconAll,
//            successCallback: { (recommendIconModels: [CJBaseImageModel], responseModel) in
//                success(recommendIconModels)
//            }, failureCallback: { (responseModel) in
//                print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
//            }
//        )

    }
    
    func requestIconData(success: @escaping ([IconLinkMenuSectionModel]) -> Void, failure: @escaping (Error) -> Void) {
        //*
        // 1秒后执行 //TODO: qian
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sectionDataModels: [IconLinkMenuSectionModel] = IconLinkMenuSectionModel.iconSectionExamples()
            success(sectionDataModels)
        }
        //*/
        /*
        CCRequestUtil.cacheRequestControlWidgetDatas(
            API.ctrIconAll,
            successCallback: { [weak self] (sectionDataModels: [IconLinkMenuSectionModel], responseModel) in
                success(sectionDataModels)
            }, failureCallback: { (responseModel) in
                print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
            }
        )
        */
    }
    
    func requestTextData(success: @escaping ([TextLinkMenuSectionModel]) -> Void, failure: @escaping (Error) -> Void) {
        //*
        // 1秒后执行 //TODO: qian
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let sectionDataModels: [TextLinkMenuSectionModel] = TextLinkMenuSectionModel.textSectionExamples()
            success(sectionDataModels)
        }
        //*/
        /*
        CCRequestUtil.cacheRequestControlWidgetDatas(
            API.textAssetAll,
            successCallback: { [weak self] (sectionDataModels: [TextLinkMenuSectionModel], responseModel) in
                success(sectionDataModels)
            }, failureCallback: { (responseModel) in
                print("网络请求失败 包括服务器错误和网络异常\(responseModel.code)__\(responseModel.message)")
            }
        )
        */
    }
}
