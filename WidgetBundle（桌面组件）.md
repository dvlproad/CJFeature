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





### 动画实现

核心：[官网下载 SF Symbols 6](https://developer.apple.com/sf-symbols/)

参考文档：

* [在 iOS 17 中使用 Symbols 呈現動感](https://www.yunserve.dev/animate-symbols-in-app/)
* [iOS 17 之 SwiftUI 5 中 SF Symbols 符号的动画效果示例](https://www.codeun.com/archives/1224.html)
* [定制属于你的 SF Symbols](https://juejin.cn/post/7166118375960739848)
