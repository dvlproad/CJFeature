//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by qian on 2025/1/9.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        
        if #available(iOS 18.0, *) {
            WidgetExtensionControl()
            // BaseDemo
            /*
            我执行以下步骤：
            运行宿主 App：ControlWidgetDemo
            打开控制中心
            添加/编辑控制组件
            选择“控制组件”或“启动组件”
            在配置列表里选“控制组3”

            我发现在iOS18上，在控制中心选择控制组件，进入列表选择"控制组3"，选中后能正确更新标题为控制组3，但在iOS26上却没法更新标题。
            然后我尝试直接运行 ControlExtExtension 这个target，却又发现我在iOS18上运行没有问题；而在iOS26上，一旦运行这个target 就提示我 Failed to build EntityIdentifier. ControlWidgetToggleEntity is not a registered AppEntity identifier，所以我就在想是不是我标题文字没更新是这个iOS26的提示要先解决才行。
            */
            ControlToggleWidget()
            ControlButtonWidget()
            
            // MyDemo
            BaseControlWidget()
        }
        
        WidgetExtensionLiveActivity()
        
        
    }
}
