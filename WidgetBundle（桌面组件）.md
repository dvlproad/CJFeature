# WidgetBundle（桌面组件）

官方文档：

[iOS各版本新功能官方文档](iOS 18 的新功能)

[将 App 控制扩展到系统级别](https://developer.apple.com/videos/play/wwdc2024/10157/)



控制中心

1、桌面处理：

1.1、新增控制中心组件，实现控制中心可搜索添加自定义的组件

1.2、控制中心组件列表：实现控制中心

2、APP内与桌面联动

控制中心可提供的组件列表

控制中心已添加的组件列表

APP内控制中心组件详情页面：

* 展示：组件信息

* 操作：新增到"我的组件"、更新到"我的组件"及"桌面的控制中心"

桌面控制中心：

* 展示：组件信息
* 操作：
  * 基本点击控制组件开关状态的变化与展示变更
  * 变更后数据的同步，提供给app内使用的数据（当前topWidget功能操作，内部UI并未自动刷新）
  * 自定义的点击，变更图文信息，功德组件连续点击



### 组件首页

- [x] 单组件
- [ ] 支持组件套
- [ ] 接入下载



我的组件



控制中心详情页





### 控制中心图标要求

* [IOS18 ControlWidget icon not show](https://stackoverflow.com/questions/79013808/ios18-controlwidget-icon-not-show)
* [ControlWidget的图标只支持SF](https://github.com/xiaof631/ControlWidgetDemo/blob/main/%E5%85%A8%E7%BD%91%E6%9C%80%E5%85%A8%E7%9A%84iOS18%20ControlWidget%E5%BC%80%E5%8F%91%E6%95%99%E7%A8%8B/%E5%85%A8%E7%BD%91%E6%9C%80%E5%85%A8%E7%9A%84iOS18%20ControlWidget%E5%BC%80%E5%8F%91%E6%95%99%E7%A8%8B.md)



### 动画实现

核心：[官网下载 SF Symbols 6](https://developer.apple.com/sf-symbols/)

资源下载：[igoutu.cn](https://igoutu.cn/icon/set/%E8%A7%92%E8%89%B2/sf-regular-filled)

资源自定义：

* [Apple官网 创建自定义符号](https://developer.apple.com/cn/videos/play/wwdc2021/10250/)

* [创建SF Symbol 符号字体](https://glyphsapp.com/zh/learn/creating-an-sf-symbol)

参考文档：

* [**SF Symbols 6 使用指南**](https://mim0sa.github.io/2024/07/08/SF-Symbols-6-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.html)
* [在设计和开发时使用 SF Symbols](https://steppark.net/15675148872165.html)
* [Apple官方文档——设计——SF 符号](https://developer.apple.com/cn/design/human-interface-guidelines/sf-symbols)

* [在 iOS 17 中使用 Symbols 呈現動感](https://www.yunserve.dev/animate-symbols-in-app/)
* [iOS 17 之 SwiftUI 5 中 SF Symbols 符号的动画效果示例](https://www.codeun.com/archives/1224.html)
* [定制属于你的 SF Symbols](https://juejin.cn/post/7166118375960739848)





## 控制中心点击颜色

//桌面的 tint 必须在 ControlWidgetToggle 的 label 下设置，不能放在label这个自定义的view内

1、点击的时候不显示任何颜色

方法：使用ControlWidgetButton，如果使用ControlWidgetToggle则点击的时候即使不设置tint值，也会有系统默认的蓝色会有一瞬间的显示

2、点击时候显示瞬间的tintColor，后面恢复的效果

方法：使用 ControlWidgetToggle 并设置isOn为false, 以及打开时候的tint，使得点击的时候可显示瞬间的颜色tintColor。

```swift
	ControlWidgetToggle( isOn: false,	// ✅
	// ControlWidgetButton(						// ❌
      action: QuickStartControlWidgetToggleAction(
          widgetId: widgetInfo.widgetId,
          widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
          desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
      ),
      label: {
          // 实际是一个Lable 可自适应实际小、中、大三种尺寸
          BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
      }
  )
  .tint(widgetInfo.tintColor) // 桌面的tint必须在此设置
```



## 控制中心动画



```swift
@available(iOS 18.0, *)
struct BaseControlWidget: ControlWidget {
    static let kind = "com.widgetBundleDemo.toggle"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in
            let widgetInfo: BaseControlWidgetEntity = item.entity.widgetInfo
            ControlWidgetToggle(
                isOn: widgetInfo.quickStartEnable == true ? false : widgetInfo.isOn, // 快捷启动使用funWidget效果只亮一瞬
                action: BaseControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.toggle.rawValue
                ),
                label: {
//                    let widgetInfo = item.entity.widgetInfo
//                    let onoffModel = widgetInfo.getStateModel()
//                    Label {
//                        Text("Running")
//                        Text("(onoffModel.subTitle)")
//                    } icon: {
//                        // 系统SF图标
//                        onoffModel.imageModel.createImageView()
////                        Image(systemName: "figure.walk")
//                            .resizable()
////                            .symbolEffect(.bounce.up.byLayer, options: .repeat(.continuous))
//                            .applyEffect(widgetInfo.symbolEffectType)
//                            .aspectRatio(contentMode: .fit) // kn: aspectRatio 要在 frame设置前，否则会导致变形(如详情的顶部headerView或者预览页面)
////                            .imageFrame(size)
//                        // 自定义SF图标
//                        // Image(entity.imageName)
//                    }
                }
            )
            .tint(widgetInfo.tintColor) // 桌面的tint必须在此设置
        }.displayName("控制组件")
            .description("自定义你的控制组件")
            .promptsForUserConfiguration()
    }
}
```





```swift
// app 外
symbolEffectType: $entity.symbolEffectType,     // 控制中心不需要自己根据状态切换动画，app内要自己切换(如果自己做切换会导致在有动画的时候闪两次)

// app 内
symbolEffectType: isOff ? .constant(.none) : $entity.symbolEffectType,
```









**不能直接在 `perform()` 中用代码唤醒应用**，因为 `openAppWhenRun` 是静态的，且系统负责决定是否将应用唤醒。





### 快捷启动

* [iOS 之 URL Scheme(含常用指令及如何查找第三方 App 的 URL Scheme)](https://hanleylee.com/articles/url-scheme-of-ios/)
* [When setting 'static var openAppWhenRun=true', clicking on the control center will keep opening the app. How can I sometimes want to open it and sometimes not.](https://github.com/onmyway133/blog/issues/983)

实现方式1：没有开闭状态之分，点击始终执行快捷启动

注意点：

```swift
// 点击快捷启动让颜色保持不变
// 查看 action 中的 openAppWhenRun 设置情况
static var openAppWhenRun: Bool = true  // 不设置此行值为true，会导致点击的时候有颜色变化再变回去


```



### 快捷指令

* [Apple 官方文档：在 iPhone 或 iPad 上使用 URL 方案运行快捷指令](https://support.apple.com/zh-cn/guide/shortcuts/apd624386f42/ios)





app外桌面组件列表增加序号、根据名称搜索

首页接口联调（资源数据；列表数据；不支持的组件弹窗升级）

图标库弹出界面及接口对接

文案库弹出页面及接口对接

搜索结果页面增加控制中心及接口联调





