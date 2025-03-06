

# WidgetControl控制和启动组件合一



### 一、目前现象

1、效果与 **Top Widget** 一致，分为"控制组件"和"启动组件"。

控制组件的操作不会打开app。

启动组件的操作会打开app。

2、实现方式：

其为不同配置，需创建为两个类管理各自操作事项。

启动与不启动app的主要控制设置为： `static var openAppWhenRun: Bool = false`

其在 控制组件中需为false，在启动组件中需为true。

该设置为一个系统的**静态变量（静态属性）**，且为只读属性，外部无法动态修改。

```swift
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension AppIntent {

    /// A boolean property that tells the system to consider the app intent even
    /// if its app is not in the foreground.
    public static var openAppWhenRun: Bool { get }
}
```



### 二、期望

1、期望：将"控制组件"和"启动组件"合成为一个组件，及一个类中。

2、难点：静态属性 `static var openAppWhenRun: Bool = false` 的设置。

3、现象

如果设置为 `false`，则合成后发现是要启动的组件，也会无法启动。

如果设置为`true`，则合成后发现那些不需要启动的控制组件，也会被启动。



### 三、区分的尝试过程

#### 代码介绍：

1、组件创建的主要代码：

```swift
struct BaseControlWidget: ControlWidget {
    static let kind = "com.widgetBundleDemo.toggle"
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in
           
          }
    }
}
```

2、独立功能的代码示例

```swift
@available(iOS 18.0, *)
struct BaseQuickStartControlWidget: ControlWidget {
    static let kind = "com.widgetBundleDemo.quickStart"
    
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseQuickStartControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in
            let widgetInfo: BaseControlWidgetEntity = item.entity.widgetInfo
            let openUrl = widgetInfo.getStateModel().getOpenUrl()
            let needOpenApp: Bool = openUrl != nil
            
            let action = QuickStartControlWidgetToggleAction(
                widgetId: widgetInfo.widgetId,
                widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
            )

            ControlWidgetToggle(
                isOn: false,
                action: action,
                label: {
                    BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                }
            )

        }.displayName("快捷启动")
            .description("快速运行你的快捷启动")
            .promptsForUserConfiguration()
    }
}
```

#### 1、在修改 ControlWidgetToggle 生成处

```swift
						needOpenApp
                ? ControlWidgetToggle(
                    isOn: false,
                    action: QuickStartControlWidgetToggleAction(
                        widgetId: widgetInfo.widgetId,
                        widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                        desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                    ),
                    label: {
                        BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                    }
                )
                : ControlWidgetToggle(
                    isOn: false,
                    action: QuickStartControlWidgetToggleAction2(
                        widgetId: widgetInfo.widgetId,
                        widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                        desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                    ),
                    label: {
                        BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                    }
                )
```

报错如下：

```swift
'buildExpression' is unavailable: this expression does not conform to 'ControlWidgetTemplate'
'buildExpression' has been explicitly marked unavailable here (SwiftUI.ControlWidgetTemplateBuilder)
```

#### 2、在 ControlWidgetToggle  的 action 设置处

##### 未改时

```swift
						let action = needOpenApp
                ? QuickStartControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                )
                : QuickStartControlWidgetToggleAction2(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                )
```

报错如下：

```swift
Result values in '? :' expression have mismatching types 'QuickStartControlWidgetToggleAction' and 'QuickStartControlWidgetToggleAction2'

// 类型不一致
```

##### 2.1、修复方法1 as Any(编译失败❌)，过程如下：

```swift
					let action = needOpenApp
                ? QuickStartControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                )
                : QuickStartControlWidgetToggleAction2(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                ) as Any
                
           ControlWidgetToggle(
                isOn: false,
                action: action,
                label: {
                    BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                }
            )
```

还报错如下：

```swift
Type 'Any' cannot conform to 'SetValueIntent'
Only concrete types such as structs, enums and classes can conform to protocols
Required by initializer 'init(isOn:action:label:)' where 'Action' = 'Any'

// ControlWidgetToggle 需要一个具体的类型
```



##### 2.2、修复方法2 通过 **类型抽象** 来统一它们的类型(编译失败❌)，过程如下：

```swift
					let action: ControlWidgetAction = needOpenApp					// 加了 ControlWidgetAction 
                ? QuickStartControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                )
                : QuickStartControlWidgetToggleAction2(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                )


// ControlWidgetAction 的定义如下：
@available(iOS 18.0, *)
protocol ControlWidgetAction: SetValueIntent, AudioPlaybackIntent, LiveActivityStartingIntent {
}
@available(iOS 18.0, *)
extension ControlWidgetAction {
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
//        let appUrl = "mobilenotes://"
        if #available(iOS 18.1, *) {
            return .result(opensIntent: OpenURLIntentIOS181(openUrl: appUrl))
        } else {
            return .result(opensIntent: OpenURLIntentIOS180(openUrl: appUrl))
        }
    }
}
```

报错如下：

```swift
Type 'any ControlWidgetAction' cannot conform to 'SetValueIntent'
Only concrete types such as structs, enums and classes can conform to protocols
Required by initializer 'init(isOn:action:label:)' where 'Action' = 'any ControlWidgetAction'

// 你使用了 any ControlWidgetAction 类型来声明 action，这意味着 action 是一个符合 ControlWidgetAction 协议的实例，但它的类型是动态的（any）。在这种情况下，编译器无法确定实际类型是什么，也无法确定它是否符合协议的具体要求（如 SetValueIntent，AudioPlaybackIntent 和 LiveActivityStartingIntent）。

//核心问题：
//ControlWidgetAction 是一个协议，不能直接作为具体的类型进行使用（尤其是作为 ControlWidgetToggle 的 action）。
// **编译器要求 ControlWidgetToggle 的 action 是一个具体的类型（例如一个结构体或类），而不是协议类型。**
// **编译器要求 ControlWidgetToggle 的 action 是一个具体的类型（例如一个结构体或类），而不是协议类型。**
// **编译器要求 ControlWidgetToggle 的 action 是一个具体的类型（例如一个结构体或类），而不是协议类型。**

// 协议 ControlWidgetAction 不能作为 ControlWidgetToggle 的 action 传递
// ControlWidgetToggle 需要一个具体的类型，而 any ControlWidgetAction 只是一个协议的引用，无法确定它是否满足 SetValueIntent 及其 ValueType 要求。
```

修复



##### 2.3、修复方法3：使用类型擦除（Type Erasure）(编译成功✅，执行结果不是想要的❌)，过程如下：

如果你必须使用 `any ControlWidgetAction`，则可以使用 **类型擦除** 来将 `ControlWidgetAction` 转换为一个具体的类型。

你可以创建一个类型擦除包装类来包裹 `ControlWidgetAction`，使它能够在运行时作为具体类型传递。例如：

```swift
@available(iOS 18.0, *)
protocol ControlWidgetAction: SetValueIntent, AudioPlaybackIntent, LiveActivityStartingIntent {
  
}

@available(iOS 18.0, *)
class AnyControlWidgetAction: ControlWidgetAction {
    static var title: LocalizedStringResource = "Open My App"
    
    required init() {
        _setValue = { value in
//            var mutableAction = action
//            mutableAction.value = value as! T.ValueType
        }
    }
    
    private let _setValue: (Bool) -> Void

    init<T: ControlWidgetAction>(_ action: T) {
        _setValue = { value in
            var mutableAction = action
            mutableAction.value = value as! T.ValueType
        }
    }
    
    @Parameter(
        title: .init("widgets.controls.parameter.value", defaultValue: "value")
    )
    var value: Bool
//    {
//        get { true } // 这里需要根据实际的 `ValueType` 进行修改
//        set { _setValue(newValue) }
//    }
  
  	@MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
//        let appUrl = "mobilenotes://"
        if #available(iOS 18.1, *) {
            return .result(opensIntent: OpenURLIntentIOS181(openUrl: appUrl))
        } else {
            return .result(opensIntent: OpenURLIntentIOS180(openUrl: appUrl))
        }
    }
}

// 使用
						let action: AnyControlWidgetAction = needOpenApp
                ? AnyControlWidgetAction(QuickStartControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                ))
                : AnyControlWidgetAction(QuickStartControlWidgetToggleAction2(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
                ))
```

运行结果情况说明：

```swift
// 执行的是 AnyControlWidgetAction 里的 perform （且AnyControlWidgetAction 里的 perform又不能不实现）,而不是希望的 AnyControlWidgetAction 里指定的Action。
```



#### 3、static var openAppWhenRun=true

```swift
@available(iOS 18.0, *)
struct BaseQuickStartControlWidget: ControlWidget {
    static let kind = "com.widgetBundleDemo.quickStart"
    
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: BaseQuickStartControlWidget.kind,
            provider: BaseToggleControlValueProvider()
        ) { item in
            let widgetInfo: BaseControlWidgetEntity = item.entity.widgetInfo
            let openUrl = widgetInfo.getStateModel().getOpenUrl()
            let needOpenApp: Bool = openUrl != nil
           
           	OpenURLIntent.openAppWhenRun = needOpenApp // 尝试修改失败，该静态属性为只读
            
            let action = QuickStartControlWidgetToggleAction(
                widgetId: widgetInfo.widgetId,
                widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                desktopWidgetControlTypeString: DesktopWidgetControlType.quickStart.rawValue
            )

            ControlWidgetToggle(
                isOn: false,
                action: action,
                label: {
                    BaseControlWidgetViewInDesktop(entity: widgetInfo, pageInfo: CCPageInfo(pageType: .inDesktop))
                }
            )

        }.displayName("快捷启动")
            .description("快速运行你的快捷启动")
            .promptsForUserConfiguration()
    }
}
```



#### 4、ForegroundContinuableIntent 尝试

ForegroundContinuableIntent  的 Apple 官网介绍 https://developer.apple.com/documentation/appintents/foregroundcontinuableintent

无法用在扩展组件中

```swift
/// A protocol you use for app intents which begin their work with the app in the background but
/// may request to continue in the foreground.
@available(macOS 13.3, iOS 16.4, watchOS 9.4, tvOS 16.4, *)
@available(iOSApplicationExtension, unavailable)
@available(tvOSApplicationExtension, unavailable)
@available(watchOSApplicationExtension, unavailable)
@available(macCatalystApplicationExtension, unavailable)
@available(macOSApplicationExtension, unavailable)
public protocol ForegroundContinuableIntent : AppIntent {
}
```







#### 5、对控制组件视图添加额外视图，拦截系统的点击操作，无效❌。尝试代码如下：

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
                isOn: widgetInfo.isOn,
                action: BaseControlWidgetToggleAction(
                    widgetId: widgetInfo.widgetId,
                    widgetSaveId: widgetInfo.saveId ?? "unknow_saveId",
                    desktopWidgetControlTypeString: DesktopWidgetControlType.toggle.rawValue
                ),
                label: {
                    ZStack {
                        Label("Running", systemImage: "hourglass")
                        
                        let appIntent = TestAppIntent(widgetId: item.entity.widgetInfo.widgetId)
                        Button(intent: appIntent) {
                            Color.red
                        }
                        .buttonStyle(.borderless)
                    }.onTapGesture {
                        debugPrint("helloworld.....")
                    }
                }
            )
            .tint(widgetInfo.quickStartEnable == true ? nil : widgetInfo.tintColor) // 桌面的tint必须在此设置
        }.displayName("控制组件")
            .description("自定义你的控制组件")
            .promptsForUserConfiguration()
    }
}
```



#### 在 perform



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





**不能直接在 `perform()` 中用代码唤醒应用**，因为 `openAppWhenRun` 是静态的，且系统负责决定是否将应用唤醒。

