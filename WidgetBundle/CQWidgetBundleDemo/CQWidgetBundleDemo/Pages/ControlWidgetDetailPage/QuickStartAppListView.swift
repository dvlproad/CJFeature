//
//  QuickStartAppListView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/18.
//

import SwiftUI

struct QuickStartAppListView: View {
    @Environment(\.presentationMode) var mode
    
    @State var showAddAppView: Bool = false
    @State var searchText: String = ""
    @State var hotApps: [QuickStartAppModel] = [] /// 常用应用
    @State var filteredApps: [QuickStartAppModel] = [] /// 搜索结果应用
    @State var diyApps: [QuickStartAppModel] = [] /// 自定义应用
    @State var currentEditApp: QuickStartAppModel?
//    var type: String
    var selectedApp: ((QuickStartAppModel) -> Void)
    @State private var refreshID = UUID() // 创建一个刷新标记
    
    
    
    
    var body: some View {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        NavigationView {
            ZStack(alignment: .top) {
                Color.white.edgesIgnoringSafeArea(.all) // 设置背景色
                
                VStack {
                    Spacer().frame(height: 5)
                    
                    HStack {
                        Spacer().frame(width: 17.5)
                        Image("app_search_icon")
                            .frame(width: 15, height: 15)
                        Spacer().frame(width: 10)
                        
                        TextField("搜索应用", text: $searchText)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#333333"))
                            .frame(height: 38)
                            .onChange(of: searchText) { oldValue, newValue in
                                searchApp() // 搜索应用
                            }

                        
                        Spacer().frame(width: 15.5)
                    }.frame(width: screenWidth - 31, height: 38)
                        .background(Color(hex: "#F5F5F5"))
                        .cornerRadius(19) //, corners: .allCorners)
                    
                    Spacer().frame(height: 16)
                    List {
                        if searchText.count > 0 {
                            if !filteredApps.isEmpty {
                                ForEach(Array($filteredApps.enumerated()), id: \.offset) { index, item in
                                    AppCell(isDiyApp: false,
                                            model: item,
                                            editApp: { app in
                                        currentEditApp = app
                                        showAddAppView = true
                                    })
//                                    .overlay(
//                                        CustomButton(tapComplete: {
//                                            fetchAppDetail(item.wrappedValue)
//                                        }, labelView: {
//                                            Color.clear
//                                        }, bgColor: Color.clear, radius: 0)
//                                    )
                                }
                            } else {
                                Text("没有搜索结果")
                                    .padding()
                            }
                        } else {
                            if diyApps.count > 0 {
                                Text("自定义应用")
                                    .foregroundColor(Color(hex: "#333333"))
                                    .font(.system(size: 15.5))
//                                    .listRowSeparatorHiddenIfiOS15(true)
                                ForEach(Array($diyApps.enumerated()), id: \.offset) { index, item in
                                    AppCell(isDiyApp: true,
                                            model: item,
                                            editApp: { app in
                                        currentEditApp = app
                                        showAddAppView = true
                                    })
//                                    .swipeActionsIfiOS15(HStack(content: {
//                                        Button(action: {
//                                            deleteApp(item.wrappedValue)
//                                        }) {
//                                            Text("删除")
//                                                .foregroundColor(Color.white)
//                                                .font(.system(size: 15.5))
//                                        }
//                                    })
//                                        .background(Color(hex: "#FF6528")))
                                    .onTapGesture {
                                        clickApp(item.wrappedValue)
                                    }
                                }
                                .id(refreshID) // 使用 UUID 触发视图重新加载
                            }
                            
                            Text("常用APP")
                                .foregroundColor(Color(hex: "#333333"))
                                .font(.system(size: 15.5))
//                                .listRowSeparatorHiddenIfiOS15(true)
//                                .listSectionSpacingIfiOS17(0)
                            
                            ForEach(Array($hotApps.enumerated()), id: \.offset) { index, item in
                                AppCell(
                                    isDiyApp: false,
                                    model: item,
                                    editApp: { app in
                                        
                                    }
                                )
                                .onTapGesture {
                                    fetchAppDetail(item.wrappedValue)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.bottom, 34)
                }
                
                
                AddAppView(showAddAppPage: $showAddAppView,
                           editApp: $currentEditApp) { (app, isEdit, isDelete) in
                    if var app = app {
                        if isDelete {
                            deleteApp(app)
//                            SWToast.showText(message: "删除成功")
                        } else {
                            updateOrAdd(&app, isEdit: isEdit)
//                            SWToast.showText(message: "保存成功")
                        }
                        
                    } else {
                        if let app = currentEditApp {
                            deleteApp(app)
//                            SWToast.showText(message: "删除成功")
                        }
                    }
                    
                    showAddAppView = false
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            fetchData()
        }
    }
    
    private func deleteApp(_ item: QuickStartAppModel) {
        for (index, app) in diyApps.enumerated() where item.uuid == app.uuid && index < diyApps.count {
            diyApps.remove(at: index)
        }
        
//        UserDefaults.standard.setValue(diyApps.toJSON(), forKey: "kDefaultKey_DiyApps")
//        UserDefaults.standard.synchronize()
    }
    
    private func fetchData() {
        hotApps = QuickStartAppExample.hotApps
        diyApps = TSQuickStartAppsUtil.getQuickStartApps()
    }
    
    private func searchApp() {
        
    }
    
    private func updateOrAdd(_ app: inout QuickStartAppModel, isEdit: Bool) {
        if isEdit {
            TSQuickStartAppsUtil.replaceQuickStartApp(app, in: &diyApps)
            refreshID = UUID() // 更新标记触发视图重绘
        } else {
            app.uuid = UUID().uuidString
            TSQuickStartAppsUtil.addQuickStartApp(app, inPrefix: true)
        }
    }
    
    private func fetchAppDetail(_ app: QuickStartAppModel) {
        clickApp(app)
    }
    
    private func clickApp(_ app: QuickStartAppModel) {
        selectedApp(app)
        self.mode.wrappedValue.dismiss()
    }
}

struct AppCell: View {
    var isDiyApp: Bool = false
    @Binding var model: QuickStartAppModel
    var editApp: ((QuickStartAppModel) -> Void)?
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer().frame(width: 22)
                    
//                    AnyView(getLoadImage(imageStr: model.icon ,
//                                         imageSize: CGSize(width: 42, height: 42), contentMode: .fill))
//                    .cornerRadius(10.5, corners: .allCorners)
//                    .clipped()
                    
                    Text(model.appName)
                        .foregroundColor(Color(hex: "#333333"))
                        .font(.system(size: 14.5))
                    Spacer()
                    if isDiyApp {
                        Text("编辑")
                            .foregroundColor(Color(hex: "#2E2E2E"))
                            .font(.system(size: 13.5))
                            .frame(width: 57, height: 30)
                            .background(Color(hex: "#EEEEEE"))
                            .cornerRadius(15) //, corners: .allCorners)
                        
                            .clipped()
                            .onTapGesture {
                                editApp?(model)
                            }
                    }
                    Spacer().frame(width: 15)
                }
                .frame(width: screenWidth, height: 50)
            }
        }.frame(width: screenWidth, height: 50)
            .background(Color.white)
//            .listRowSeparatorTintIfiOS15(lineColor)
    }
}

struct AddAppView: View {
    @Binding var showAddAppPage: Bool
    @State var showPermisionView: Bool = false
    @State var isShowingImagePicker: Bool = false
    @State private var showingCropView = false
    @Binding var editApp: QuickStartAppModel?
    @State var logo: UIImage?
    @State var name: String = ""
    @State var url: String = ""
//    @ObservedObject var selectedImage: AssetImage = AssetImage(image: UIImage(named: "quickStart_default_1"), isSelected: false, selectedIndex: 0)
    let logoSize = CGSize(width: 72, height: 72)
    
    var editAppComplete: ((QuickStartAppModel?, _ isEdit: Bool, _ isDelete: Bool) -> Void)?
    let maxLength = 100
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            Color(hex: "#000000").opacity(showAddAppPage ? 0.2 :0).edgesIgnoringSafeArea(.all)
            //                .onTapGesture {
            //                    showAddAppPage = false
            //                    clearData()
            //                }
            if showAddAppPage {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            showAddAppPage = false
                            clearData()
                        } label: {
                            Image(uiImage: UIImage(named: "wi_close_gray") ?? UIImage())
                                .frame(width: 34.5, height: 34.5)
                                .padding([.trailing], 15)
                                .padding([.top], 17)
                        }
                    }
                    .frame(height: 34.5)
                    
                    ZStack(content: {
                        if let image = logo {
                            Image(uiImage: image)
                                .resizable()
                            
//                        } else if let logo = editApp?.icon {
//                            AnyView(getLoadImage(imageStr: logo,
//                                                 imageSize: logoSize,
//                                                 contentMode: .fill))
                        } else {
                            Image("quickStart_default_1")
                                .resizable()
                        }
                    })
                    .frame(width: logoSize.width, height: logoSize.height)
                    .cornerRadius(10.5) //, corners: .allCorners)
                    
                    
                    Spacer().frame(height: 20)
                    
                    HStack(alignment: .center) {
                        Text("更换图标")
                            .font(.system(size: 14.5, weight: .regular))
                            .foregroundColor(Color(hex: "#333333"))
                            .padding(.leading, 14)
                        
                        Spacer()
                        
                        Text("点击上传")
                            .font(.system(size: 13.5,weight: .regular))
                            .foregroundColor(Color(hex: "#999999"))
                        Spacer().frame(width: 10)
                        
                        Image("arrow_right")
                            .resizable()
                            .frame(width: 6.5,height: 11)
                            .foregroundColor(Color(hex: "#999999"))
                            .padding(.trailing, 20)
                    }.frame(height: 44)
//                        .overlay(
//                            CustomButton(tapComplete: {
//                                PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { status in
//                                    switch status {
//                                    case .authorized:
//                                        delay(0) {
//                                            isShowingImagePicker = true
//                                        }
//                                    case .denied, .limited:
//                                        delay(0) {
//                                            showPermisionView = true
//                                        }
//                                    case .notDetermined:
//                                        print("权限尚未请求")
//                                    case .restricted:
//                                        print("此应用无权访问")
//                                    @unknown default:
//                                        print("未知的权限状态")
//                                    }
//                                }
//                            }, labelView: {
//                                Color.clear
//                            }, bgColor: Color.clear, radius: 0)
//                            
//                        )
                    
                    HStack(alignment: .center) {
                        Text("捷径名称")
                            .font(.system(size: 14.5,weight: .regular))
                            .foregroundColor(Color(hex: "#333333"))
                            .padding(.leading, 14)
                        Spacer().frame(width: 68)
                        
                        TextField("自定义",
                                  text: $name)
                        .font(.system(size: 13.5,weight: .regular))
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 30)
                        .multilineTextAlignment(.trailing)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                        .onChange(of: name, perform: { newValue in
                            guard newValue.count <= self.maxLength else {
                                name = String(newValue.prefix(self.maxLength))
                                return
                            }
                            name = newValue
                        }).onAppear {
                            name = editApp?.appName ?? ""
                        }
//                        .submitLabelDoneIfiOS15()
                        
                        
                    }.frame(height: 45)
                    
                    HStack(alignment: .center) {
                        Text("捷径URL")
                            .font(.system(size: 14.5,weight: .regular))
                            .foregroundColor(Color(hex: "#333333"))
                            .padding(.leading, 14)
                        Spacer().frame(width: 68)
                        
                        TextField("请输入捷径URL",
                                  text: $url)
                        .font(.system(size: 13.5,weight: .regular))
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 30)
                        .multilineTextAlignment(.trailing)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
//                        .submitLabelDoneIfiOS15()
                        .onChange(of: url, perform: { newValue in
                            url = newValue
                        })
                        .onAppear {
                            url = editApp?.targetUrl ?? ""
                        }
                        
                        
                    }.frame(height: 45)
                    
                    Spacer().frame(height: 10)
                    
                    HStack(content: {
                        Text("若有安装此APP，即可跳转成功")
                            .foregroundColor(Color(hex: "#999999"))
                            .font(.system(size: 11.5))
                            .padding(.leading, 14)
                        Spacer()
                    })
                    
                    Spacer().frame(height: 20)
                    
                    HStack(content: {
                        let buttonWidth: CGFloat = editApp == nil ? 245 : (245 - 14) / 2
                        let buttonHeight: CGFloat = 38
                        if editApp != nil {
                            Button {
//                                let alert = SWAlertController(title: "温馨提示",
//                                                              message: "确定删除该APP？",
//                                                              confirmTitle: "删除",
//                                                              confirmHandler: {action in
//                                    editAppComplete?(editApp, true, true)
//                                    clearData()
//                                },
//                                                              cancelTitle: "取消",
//                                                              cancelHandler: { action in
//                                })
//                                alert.show()
                                
                            } label: {
                                Text("删除APP")
                                    .frame(width: buttonWidth, height: buttonHeight)
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color(hex: "#EEEEEE"))
                            .foregroundColor(Color(hex: "#333333"))
                            .font(.system(size: 16))
                            .cornerRadius(buttonHeight / 2)
                            
                            Spacer().frame(width: 14)
                        }
                        
                        Button {
                            guard name.count > 0 else {
//                                SWToast.showText(message: "应用名不能为空")
                                return
                            }
                            guard url.count > 0 else {
//                                SWToast.showText(message: "URL不能为空")
                                return
                            }
                            
                            let fileName = "\(UUID().uuidString)_Material"
                            
                            if var app = editApp {
                                app.appName = name
                                app.targetUrl = url
//                                if let image = logo {
//                                    app.icon = saveImage(image: reImage(image: image, showSize: CGSizeMake(80, 80), family: .systemSmall), fileName: fileName) ?? "quickStart_default_1"
//                                    app.iconMaterial = app.icon
//                                    app.blockMaterial = app.icon
//                                    app.quickStartImage = logo
//                                }
                                editAppComplete?(app, true, false)
                                
                            } else {
                                let app = QuickStartAppModel.customAppModel(appName: name, targetUrl: url)

//                                if let image = logo {
//                                    app.icon = saveImage(image: reImage(image: image, showSize: CGSizeMake(80, 80), family: .systemSmall), fileName: fileName) ?? "quickStart_default_1"
//                                    app.iconMaterial = app.icon
//                                    app.blockMaterial = app.icon
//                                    app.quickStartImage = logo
//                                }
                                editAppComplete?(app, false, false)
                            }
                            clearData()
                        } label: {
                            Text("保存")
                                .frame(width: buttonWidth, height: buttonHeight)
                        }
                        .frame(width: buttonWidth, height: buttonHeight)
                        .background(Color(hex: "#2E2E2E"))
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .cornerRadius(buttonHeight / 2)
                    })
                    
                    Spacer().frame(height: 20.5)
                }
                .frame(width: screenWidth - 76)
                .background(Color.white)
                .cornerRadius(12.5) //, corners: .allCorners)
                .clipped()
//                .fullScreenCover(isPresented: $isShowingImagePicker) {
//                    @State var selectArray: [AssetImage] = []
//                    PhotoSelectVC(isShowingImagePicker: $isShowingImagePicker,
//                                  selectArray: $selectArray,
//                                  selectedMaxIndex: 1) { selectImages in
//                        if selectImages.count > 0 {
//                            selectedImage.image = selectImages[0].image
//                            showingCropView = true
//                        }
//                    }
//                }
//                .fullScreenCover(isPresented: $showingCropView) {
//                    CropView(image: (selectedImage.image)!,
//                             family: .systemSmall,
//                             customAspectRatio: CGSize(width: 72, height: 72)) { croppedImage in
//                        
//                        logo = croppedImage
//                        
//                        showingCropView = false
//                    }onCancel: {
//                        showingCropView = false
//                    }
//                    .edgesIgnoringSafeArea(.all)
//                }
            }
            
//            PhotoPermisionAlertView(showingAlert: $showPermisionView,
//                                    showPhotoSelectVC: $isShowingImagePicker)
        }
//        .keyboardAwareModifier(80)
    }
    
    private func clearData() {
        editApp = nil
        logo = nil
        name = ""
        url = ""
//        selectedImage.image = UIImage(named: "app_icon_default")
    }
}

//#Preview {
//    AppListVC(type: "0")
//}
