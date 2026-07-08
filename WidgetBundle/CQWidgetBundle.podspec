Pod::Spec.new do |s|
  # 验证方法：pod lib lint CQWidgetBundle.podspec --allow-warnings --use-libraries --verbose
  # pod的本地索引文件：~/Library/Caches/CocoaPods/search_index.json
  s.name         = "CQWidgetBundle"
  s.version      = "0.1.0"
  s.summary      = "桌面小组件(Widget)"
  s.homepage     = "https://github.com/dvlproad/CJFeature"

  s.description  = <<-DESC
                 桌面小组件(Widget)，可按需独立引入：
                 • CQWidgetBundle/Common - Common
                 • CQWidgetBundle/CommonUI - 公用基础UI(Button等)
                 • CQWidgetBundle/EmptyView - 无数据时候的空视图
                 • CQWidgetBundle/ControlWidgetHelpPage - ControlWidget 的帮助页面

                 每个子库可独立引入，详见各子库描述。
                 DESC
  

  #s.license      = {
  #  :type => 'Copyright',
  #  :text => <<-LICENSE
  #            © 2008-2016 Dvlproad. All rights reserved.
  #  LICENSE
  #}
  s.license      = "MIT"

  s.author   = { "dvlproad" => "" }

  s.platform     = :ios, "12.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJFeature.git", :tag => "CQWidgetBundle_0.1.0" }
  # s.source_files  = "CQWidgetBundle/*.{h}"

  s.frameworks = "UIKit"
  s.swift_version = '5.0'

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  # s.resources = "CQWidgetBundle/**/*.{png,xib}"
  # s.frameworks = "MediaPlayer"
  # s.dependency 'Masonry'

  # Common
  s.subspec 'Common' do |ss|
    ss.source_files = "CQWidgetBundle/Common/**/*.{swift}"
  end

  # 公用基础UI(Button、HostingView等)
  s.subspec 'CommonUI' do |ss|
    ss.source_files = "CQWidgetBundle/CommonUI/**/*.{swift}"
  end

  # 无数据时候的空视图
  s.subspec 'EmptyView' do |ss|
    ss.source_files = "CQWidgetBundle/EmptyView/**/*.{swift}"
    ss.dependency 'lottie-ios'
    ss.dependency 'CQWidgetBundle/Common'   # 需要使用 .cj_width
    ss.dependency 'CQWidgetBundle/CommonUI' # 需要使用 CustomButton
  end

  # ControlWidget 的帮助页面
  s.subspec 'ControlWidgetHelpPage' do |ss|
    ss.source_files = "CQWidgetBundle/ControlWidgetHelpPage/**/*.{swift}"
    ss.dependency 'CJBaseUIKit-Swift/Color'
    ss.dependency 'CQWidgetBundle/EmptyView'
  end

  # ControlWidget 的首页预览页面
  s.subspec 'ControlWidgetHomePreviewPage' do |ss|
    ss.source_files = "CQWidgetBundle/ControlWidgetHomePreviewPage/**/*.{swift}"
    ss.dependency 'CJViewElement-Swift/Extension' # 需要 CJColorExtension.swift
    ss.dependency 'CJCollectionViewLayout-Swift/FlowLayout'
    ss.dependency 'SDWebImageWebPCoder'
    ss.dependency 'SnapKit'
    ss.dependency 'CQWidgetBundleCommon/ControlWidgetStyle'
  end

end
