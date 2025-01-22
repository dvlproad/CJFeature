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





### 快捷启动

* [iOS 之 URL Scheme(含常用指令及如何查找第三方 App 的 URL Scheme)](https://hanleylee.com/articles/url-scheme-of-ios/)
* [When setting 'static var openAppWhenRun=true', clicking on the control center will keep opening the app. How can I sometimes want to open it and sometimes not.](https://github.com/onmyway133/blog/issues/983)

**整合状态变更的控制中心组件和启动app的控制组件在同一个组件里；**

使用 AppIntent ，设置 static var openAppWhenRun=true 可打开 app，但会导致每次点击控制中心组件都会调到 app 里，导致那些类似只要切换开关状态的也出现此问题。

所以去掉 AppIntent 及 static var openAppWhenRun=true ，改用 

```swift
func perform() async throws -> some IntentResult & OpensIntent {
	......
  // 重要：打开容器App的操作
  if let appUrl = widgetModel.appModel?.targetUrl {
      return .result(opensIntent: OpenURLIntent(URL(string: appUrl)!))
  } else {
      return .result(opensIntent: OpenURLIntent(URL(string: "noexsitApp://")!))
  }
}
```





### 快捷指令

* [Apple 官方文档：在 iPhone 或 iPad 上使用 URL 方案运行快捷指令](https://support.apple.com/zh-cn/guide/shortcuts/apd624386f42/ios)
