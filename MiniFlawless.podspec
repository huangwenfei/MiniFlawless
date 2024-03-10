
Pod::Spec.new do |spec|

  spec.name           = "MiniFlawless"
  spec.version        = "0.0.3.3"
  spec.summary        = "Simple Animate."
  spec.description    = <<-DESC
        Simple Animate ...
                   DESC
  spec.homepage       = "https://github.com/huangwenfei/MiniFlawless"
  spec.license        = { :type => "BSD 3-Clause", :file => "LICENSE" }
  spec.author         = { "黄文飞" => "yi.yuan.zi@163.com" }
  spec.platform       = :ios, "12.0"
  spec.source         = { :git => "https://github.com/huangwenfei/MiniFlawless.git", :tag => spec.version }
  spec.source_files   = "Sources", "Sources/**/*.swift"
  spec.exclude_files  = "Sources/Supporting Files/*", "Sources/Item List/*", "Sources/Manager/MiniFlawlessManager.swift", "Sources/Manager/MiniFlawlessAnimatorGroup.swift", "Sources/Extensions/SwiftBool+MiniFlawless.swift"
  spec.swift_versions = ['5.1', '5.2', '5.3', '5.4', '5.5']
  spec.frameworks     = "UIKit", "QuartzCore", "CoreGraphics"
  
end
