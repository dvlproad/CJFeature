//
//  ControlWidgetAppSelectView.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/15.
//

import SwiftUI
//
//struct ControlWidgetAppSelectView: View {
//    @State var appModel: WIAppModel?
//    @Binding var isActive: Bool
//    var type: String
//    var onChangeOfApp: ((WIAppModel) -> Void)
//    
//    init(appModel: WIAppModel? = nil,
//         isActive: Binding<Bool>,
//         type: String,
//         onChangeOfApp: @escaping (WIAppModel) -> Void
//    ) {
//        self.appModel = appModel
//        self._isActive = isActive
//        self.type = type
//        self.onChangeOfApp = onChangeOfApp
//    }
//    
//    var body: some View{
//
//        NavigationLink(isActive: $isActive) {
//            AppListVC(type: type) { selectedApp in
//                /// 选应用时自定义应用返回的是已保存到本地的图片地址，由于偏大灵动岛显示不了 需要取出来重新保存下
//                var filePath = selectedApp.iconMaterial.count > 0 ? selectedApp.iconMaterial : selectedApp.icon
//                if !filePath.hasPrefix("http") {
//                    filePath = getDocumentsDirectory()!.appendingPathComponent(filePath).path
//                    if let image = UIImage(contentsOfFile:filePath) {
//                        selectedApp.quickStartImage = image
//                    }
//                }
//                
//                onChangeOfApp(selectedApp)
//                
//            }.navigationBarHidden(true)
//        } label: {
//            /*
//            HStack(spacing: 0){
//                Text("当前APP")
//                    .font(.system(size: 15.5,weight: .medium))
//                    .foregroundColor(Color(hex: "#333333"))
//                HStack(spacing: 4){
//                    Spacer()
//                    AnyView(getLoadImage(imageStr: appModel?.icon ?? "", imageSize: CGSize(width: 20, height: 20), contentMode: .fill))
//                        .cornerRadius(4)
//                    
//                    Text(appModel?.appName ?? "")
//                        .font(.system(size: 14,weight: .regular))
//                        .foregroundColor(Color(hex: "#999999"))
//                    Image("arrow_right")
//                        .resizable()
//                        .frame(width: 6.5,height: 11)
//                        .foregroundColor(Color(hex: "#999999"))
//                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
//                }
//            }
//            */
//        }
//
//    }
//}

//#Preview {
//    AccessoryAppSelectView()
//}
