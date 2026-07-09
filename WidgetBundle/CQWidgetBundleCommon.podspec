# pod的本地索引文件：~/Library/Caches/CocoaPods/search_index.json

Pod::Spec.new do |s|
  s.name         = "CQWidgetBundleCommon"
  s.version      = "0.1.0"
  s.summary      = "桌面小组件(Widget)中App内和桌面都需要使用到的部分"
  s.homepage     = "https://github.com/dvlproad/CJFeature"

  s.description  = <<-DESC
                 桌面小组件(Widget)中App内和桌面都需要使用到的部分，可按需独立引入：
                 • CQWidgetBundleCommon/ControlWidgetStyle - ControlWidgetStyle
                 • CQWidgetBundleCommon/BaseControlWidgetEntity - BaseControlWidgetEntity
                 • CQWidgetBundleCommon/BaseControlWidgetAnimationView - BaseControlWidgetAnimationView
                 • CQWidgetBundleCommon/PageInfo - PageInfo

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
 
  s.source       = { :git => "https://github.com/dvlproad/CJFeature.git", :tag => "CQWidgetBundleCommon_0.1.0" }
  # s.source_files  = "CQWidgetBundleCommon/*.{h}"

  s.frameworks = "UIKit"
  s.swift_version = '5.0'

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  # s.resources = "CQWidgetBundleCommon/**/*.{png,xib}"
  # s.frameworks = "MediaPlayer"
  # s.dependency 'Masonry'

  # ControlWidgetStyle
  s.subspec 'ControlWidgetStyle' do |ss|
    ss.source_files = "CQWidgetBundleCommon/ControlWidgetStyle/**/*.{swift}"
  end

  # BaseControlWidgetEntity
  s.subspec 'BaseControlWidgetEntity' do |ss|
    ss.source_files = "CQWidgetBundleCommon/BaseControlWidgetEntity/**/*.{swift}"
    ss.dependency 'CJAnimationKit-Swift/Extension'  # 需要 SymbolEffectType
    ss.dependency 'CJBaseUIKit-Swift/Color'
  end

  # PageInfo
  s.subspec 'PageInfo' do |ss|
    ss.source_files = "CQWidgetBundleCommon/PageInfo/**/*.{swift}"
  end

  # BaseControlWidgetAnimationView
  s.subspec 'BaseControlWidgetAnimationView' do |ss|
    ss.source_files = "CQWidgetBundleCommon/BaseControlWidgetAnimationView/**/*.{swift}"
  end

  # SaveUtil  # 因为无法处理好标记的 TSWidgetBundleCacheUtil 的解耦易错点 ，所以不添加为子库
  # s.subspec 'SaveUtil' do |ss|
  #   ss.source_files = "CQWidgetBundleCommon/SaveUtil/**/*.{swift}"
  # end



end
