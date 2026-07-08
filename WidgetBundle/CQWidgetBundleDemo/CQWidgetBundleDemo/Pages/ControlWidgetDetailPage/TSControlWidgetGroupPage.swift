//
//  TSControlWidgetGroupPage.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/9.
//

import SwiftUI
import WidgetKit
import CQWidgetBundleCommon // 需要引入 ControlWidgetStyle
import CQWidgetBundle

struct DownloadZipModel: Identifiable {
    var id: String  // 组件显示的id(同一个组件显示在不同地方会是不同id)
    var zipUrl: String
}

struct TSControlWidgetGroupPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    var fromPageType: CCPageType
    @State var groupModel: BaseControlWidgetSetModel
    @State var selectedItemIds: [String]
    
    init(fromPageType: CCPageType, groupModel: BaseControlWidgetSetModel) {
        self.fromPageType = fromPageType
        self.dataState = .successPerfect
        
        self.groupModel = groupModel
        
        self.selectedItemIds = []
        for entity in self.groupModel.entitys {
            self.selectedItemIds.append(entity.id)
        }
    }
    
    init(fromPageType: CCPageType, previewModel: ControlWidgetPreviewModel) {
        self.fromPageType = fromPageType
        self.dataState = .loading
        
        /*
        // 使用一个大zip
        if let zipUrl = previewModel.configFile {
            self.downloadZipUrls = [zipUrl]
        }
        */
        // 改为多个小zip
        var zipModels: [DownloadZipModel] = []
        if previewModel.groupModels.count > 0 {
            for previewGroupModel in previewModel.groupModels {
                let zipShowId = previewGroupModel.id
                let zipUrl = previewGroupModel.configFile ?? ""
                let downloadZipModel = DownloadZipModel(id: zipShowId, zipUrl: zipUrl)
                zipModels.append(downloadZipModel)
            }
        }
        self.downloadZipModels = zipModels

        let entitys: [BaseControlWidgetEntity] = [
        ]
        self.groupModel = BaseControlWidgetSetModel(id: previewModel.id, name: previewModel.name, entitys: entitys)
        
        self.selectedItemIds = []
        for entity in entitys {
            self.selectedItemIds.append(entity.id)
        }
    }
    func viewDidLoad() {
        if let zipModels = downloadZipModels {
            downloadZip(zipModels, completeBlock: { isSuccess in
                sendEventIfNeed()   // 异步加载完毕后，要上报
            })
        } else {
            
        }
    }
    
    var downloadZipModels: [DownloadZipModel]?
    @State var dataState: ControlWidgetDataState //控制中心组件数据的状态
    private func downloadZip(_ zipModels: [DownloadZipModel], completeBlock: @escaping ((_ isSuccess: Bool)->Void)) {
        guard zipModels.count > 0 else { return }
        
        //var downloadResponseModels = [DownloadResponseModel<BaseControlWidgetEntity>]()
        var downloadResponseModels: [DownloadResponseModel<BaseControlWidgetEntity>?] = Array(repeating: nil, count: zipModels.count)
        let dispatchGroup = DispatchGroup()  // 创建线程组
        let queue = DispatchQueue(label: "com.controlWidget.group.zip.downloadQueue")  // 自定义的并发队列
        for (index, zipModel) in zipModels.enumerated() {
            dispatchGroup.enter()  // 添加一个任务到线程组
            let zipUrl = zipModel.zipUrl
            DownloadResourceUtil.app_downloadJsonZipUrl(zipUrl, isEncryption: true, success: { (dataModel: BaseControlWidgetEntity) in
                debugPrint("套图组件信息下载成功: \(zipUrl) \n\(dataModel)")
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
            self.groupModel.entitys = downloadEntitys
            
            // 主线程
            DispatchQueue.main.async {
                if allErrorMessage == nil, downloadEntitys.count > 0 {
                    self.selectedItemIds = []
                    for entity in self.groupModel.entitys {
                        self.selectedItemIds.append(entity.id)
                    }
                    self.dataState = .successPerfect
                    completeBlock(true)
                } else {
                    self.dataState = .failure
                    completeBlock(false)
                }
            }
        }
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
        NavigationView { // 解决部分item进入会多出一个返回按钮
            bodyContent
        }
    }
    
    @State private var hasAppeared = false
    @State private var isDisappeared = true
    @Environment(\.scenePhase) private var scenePhase
    func sendEventIfNeed() {
        if dataState == .successPerfect {
            CCControlWidgetEventUtil.browseGroupId(self.groupModel.id, selectedEntitys: self.groupModel.entitys)
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
            let title = "\(groupModel.name)"
            NavigationBarView(
                title: title,
                titleViewIsLeft: false,
                hideBackBtn: false,
                rightButtonContent: {
                    EmptyView()
                },
                leftComplete: {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .background(Color(hex: "#F5F5F5"))
        }
        .frame(width: UIScreen.main.bounds.width)
        .edgesIgnoringSafeArea(.all)
//        .adjustForKeyboard()
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
//                            
//                        })
//                    }
//                })
                //Text("加载中...")
                Spacer()
            }
            
//            if(titleArray.count == 0){
//                Spacer()
//                HomePageNoDataView(noDataType: $noDataType) {
//                    noDataType = 2
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        menuApi()
//                        requestLocationPermission1()
//                    }
//                }
//                Spacer()
//            }
        }
    }
    
    var successContentView: some View {
        VStack(alignment: .center, spacing: 0) {
            headerView
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical) {
                    settingView(
                        geoWidth: UIScreen.main.bounds.width - 2 * horizontalPadding,
                        scrollViewProxy: scrollViewProxy
                    )
                        .padding(.horizontal, horizontalPadding)
//                        .padding(.bottom, 50.0) // 额外增加点底部距离，避免滑动结束后尾部刚和和其他视图顶部贴住
                        .padding(.bottom, max(50.0, keyboardObserver.keyboardHeight-40)) // 添加底部填充距离
                        .animation(.easeOut(duration: 0.3), value: keyboardObserver.keyboardHeight)
                }
            }
            
            editButton
                .padding(.top, 21.5)
            
            addOrUpdateButton
                .padding(.top, 21.5)
            
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .onReceive(NotificationCenter.default.publisher(for: .entitysModified)) { notification in
            // 接收到通知后，更新视图
            if var updatedEntitys = notification.object as? [BaseControlWidgetEntity] {
                // 更新每个 Entity 的 widgetStyle 状态
                let newWidgetStyle: ControlWidgetStyle = .circle
                for index in updatedEntitys.indices {
                    updatedEntitys[index].widgetStyle =  newWidgetStyle
                    updatedEntitys[index].isOffInDetailPage = false // 即使是在关闭状态时候进行的编辑完成更新到套图组件列表，重新在详情里显示时候都应该以打开显示
                }
                self.groupModel.entitys = updatedEntitys
            }
        }
    }

    var headerView: some View {
        return ControlWidgetGridView(
            dataModels: self.groupModel.entitys,
            enableTintColor: .constant(true)
        )
        .background(Color(hex: "#F5F5F5"))
        .padding(.top, contentToTitleDistance)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)))
    }
    
    @State var defaultSegmentModel: BaseSegmentModel?
    @State var currentSegmentModel: BaseSegmentModel?
    
    func settingView(geoWidth: CGFloat, scrollViewProxy: ScrollViewProxy) -> some View {
        VStack(alignment: .center, spacing: 0) {
            chooseView()
                .padding(.top, titlePaddingTop)
        }
    }
    
    private let titlePaddingTop: CGFloat = 25.0
    private let contentToTitleDistance: CGFloat = 15.0
    
    func chooseView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            widgetChooseView()
        }
    }
    
    func widgetChooseView() -> some View {
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
                    self.groupModel.entitys.first
                },
                set: {
                    self.groupModel.entitys[0] = $0!
//                    entity.isOffInDetailPage = forCloseState
                }
            )
            let forCloseState = false
            ControlWidgetVerticalScrollView(
                dataModels: self.groupModel.entitys,
                selectedIds: self.$selectedItemIds,
                enableTintColor: .constant(!forCloseState),
                onChangeOfSelectedIds: { newSelectedIds in
                    dismissKeyboard()
                    self.selectedItemIds = newSelectedIds
//                    entity = newIconModel
//                    updateNewIconModel(newIconModel, for: forCloseState)
                }
            )
            .padding(.top, contentToTitleDistance)
        }
    }
    
    var editButton: some View {
        NavigationLink(
            destination: TSControlWidgetDetailPage(fromPageType: .controlWidgetGroupPage, setModel: groupModel),
            label: {
                Text("编辑控制项")
                    .font(.system(size: 15.5, weight: .regular))
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 确保label填充整个按钮区域，避免点击区域只有文字部分
            }
        )
        .frame(width: 270, height: 15)
        /*
        Button(
            action: {
                self.groupModel = BaseControlWidgetSetModel(id: "", name: "", entitys: self.groupModel.entitys)
                self.navigator?.push(NavScreen.controlWidgetDetailBySet(groupModel))
            },
            label: {
                Text("编辑控制项")
                    .font(.system(size: 15.5, weight: .regular))
                    .foregroundColor(Color(hex: "#FE4E38"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 确保label填充整个按钮区域，避免点击区域只有文字部分
            }
        )
        .frame(width: 270, height: 15)
        */
        //.background(Color(hex: "#2E2E2E")) // 设置按钮背景色
        //.cornerRadius(24) // 设置按钮圆角
    }
    
    var addOrUpdateButton: some View {
        Button(
            action: {
                if self.selectedItemIds.count == 0 {
                    TSToastUtil.showMessage("请先选择要保存的控制项")
                    return
                }
                
                var selectedEntitys: [BaseControlWidgetEntity] = []
                for selectedItem in self.selectedItemIds {
                    let entity = self.groupModel.entitys.filter({ $0.id == selectedItem }).first!
                    selectedEntitys.append(entity)
                }
                TSWidgetBundleCacheUtil.addControlWidgetEntitys(selectedEntitys)
                //WIToastView.showView(hintType: .success, hintStr: "成功添加至【我的组件】")
                CCControlWidgetEventUtil.saveGroupId(groupModel.id, selectedEntitys: selectedEntitys)
                
                
                if(UserDefaults.standard.object(forKey: "firstAddControlWidget") == nil) {
                    UserDefaults.standard.setValue(true, forKey: "firstAddControlWidget")
                    //NotificationCenter.default.post(name: Notification.Name("kNoti_showTutorial_AddControlWidget"), object: nil)
                }
                
                self.presentationMode.wrappedValue.dismiss()
            },
            label: {
                let countText = self.selectedItemIds.count > 0 ? "x\(self.selectedItemIds.count)" : ""
                Text("保存控制项\(countText)")
                    .font(.system(size: 15.5, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 确保label填充整个按钮区域，避免点击区域只有文字部分
            }
        )
        .frame(width: 270, height: 48)
        .background(Color(hex: "#2E2E2E")) // 设置按钮背景色
        .cornerRadius(24) // 设置按钮圆角
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}




import Foundation
import SwiftUI
/*
class TSControlWidgetGroupViewModel: ObservableObject {
    init() {
        // 注册通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntitysModified(_:)), name: .entitysModified, object: nil)
    }
    
    deinit {
        // 确保在销毁时移除通知监听
        NotificationCenter.default.removeObserver(self, name: .entitysModified, object: nil)
    }
    
    @Published var groupModel: BaseControlWidgetSetModel
    
    @objc func handleEntitysModified(_ notification: Notification) {
        if let updatedEntitys = notification.object as? [BaseControlWidgetEntity] {
            self.groupModel.entitys = updatedEntitys
        }
    }
}
*/

extension Notification.Name {
    static let entitysModified = Notification.Name("entitysModified")
}
