
Pod::Spec.new do |spec|

  spec.name           = "MiniFlawless"
  spec.version        = "0.0.2.3"
  spec.summary        = "Simple Animate."
  spec.description    = <<-DESC
        Simple Animate ...
                   DESC
  spec.homepage       = "https://gitee.com/windyhuangwenfei/MiniFlawless"
  spec.license        = { :type => "BSD 3-Clause", :file => "LICENSE" }
  spec.author         = { "黄文飞" => "yi.yuan.zi@163.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://gitee.com/windyhuangwenfei/MiniFlawless.git", :tag => spec.version }
  spec.source_files   = "Sources", "Sources/**/*.swift"
  spec.exclude_files  = "Sources/Supporting Files/*", "Sources/Item List/*", "Sources/Manager/MiniFlawlessManager.swift", "Sources/Manager/MiniFlawlessGroup.swift", "Sources/Extensions/SwiftBool+MiniFlawless.swift"
  spec.swift_versions = ['5.1', '5.2', '5.3', '5.4', '5.5']
  spec.frameworks     = "UIKit", "QuartzCore", "CoreGraphics"
  
end
