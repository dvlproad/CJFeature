Pod::Spec.new do |s|
  #验证方法：pod lib lint CJFeature.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJFeature"
  s.version      = "0.0.1"
  s.summary      = "自定义的基础UI"
  s.homepage     = "https://github.com/dvlproad/CJFeature"

  s.description  = <<-DESC
                 - CJFeature/CJRichScan：扫码

                   A longer description of CJFeature in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  #s.license      = {
  #  :type => 'Copyright',
  #  :text => <<-LICENSE
  #            © 2008-2016 Dvlproad. All rights reserved.
  #  LICENSE
  #}
  s.license      = "MIT"

  s.author   = { "dvlproad" => "" }

  s.platform     = :ios, "8.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJFeature.git", :tag => "CJFeature_0.0.1" }
  #s.source_files  = "CJBaseUIKit/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  s.subspec 'CJRichScan' do |ss|
    ss.subspec 'CJBaseCodeReaderView' do |sss|
      sss.source_files = "CJRichScan/CJBaseCodeReaderView/**/*.{h,m}"
      sss.resources = "CJRichScan/CJBaseCodeReaderView/**/*.{png}"
      sss.dependency 'Masonry'
    end

    ss.subspec 'CJCodeReaderViewController' do |sss|
      sss.source_files = "CJRichScan/CJCodeReaderViewController/**/*.{h,m}"
      sss.resources = "CJRichScan/CJCodeReaderViewController/**/*.{wav}"
      sss.frameworks = "AVFoundation"
      sss.dependency 'Masonry'
    end
  end


end
