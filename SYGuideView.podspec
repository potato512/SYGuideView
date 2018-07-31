Pod::Spec.new do |s|
  s.name         = "SYGuideView"
  s.version      = "1.0.0"
  s.summary      = "SYGuideView used to show guide while the app is first use."
  s.homepage     = "https://github.com/potato512/SYGuideView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/potato512/SYGuideView.git", :tag => "#{s.version}" }
  s.source_files  = "SYGuideView/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true
end
