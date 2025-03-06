//
//  ControlWidgetAudioSettingView.swift
//  WidgetIsland
//
//  Created by qian on 2025/1/20.
//

import SwiftUI
import Photos
//import IQKeyboardManagerSwift

class ShakeMusicModel {
    ///0 无通知 1消息通知 2灵动岛通知
    var notificationType:Int = 0
    var permission:Bool = false
    var haveAudio:Bool = false
    var selectAudio:Int = 0
    
    var audioInfoModels:[AudioInfoModel] = []
    
}
class AudioInfoModel {
    
}

struct ControlWidgetAudioSettingView: View {
//    @EnvironmentObject var editStatus: EditStatusModel
//    var viewModel: any ViewModel
    var model: ShakeMusicModel
    @State private var keyboardHeight: CGFloat = 0
    var scroller: ScrollViewProxy
//    var scrollerId: String
    @State var scrollerEdit:Int = 0
    @State var haveAudio:Bool
    @State var notificationType:Int
    @State var selectAudio:Int

    var body: some View {
        Text("todo")
    }
}
