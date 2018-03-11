
Pod::Spec.new do |s|

  s.name             = 'Roy'
  s.version          = '0.0.2'
  s.summary          = '一个轻量组件化支持框架'
  s.module_name  = 'Roy'
  s.description      = <<-DESC
    empty
                       DESC
  s.platform     = :ios, "8.0"
  s.homepage         = 'https://github.com/jinqiucheng1006@live.cn/Roy'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'jinqiucheng1006@live.cn'
  s.source           = { :git => 'https://github.com/NicolasKim/Roy.git', :branch => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspecs = 'Core', 'UI'
  s.subspec 'Core' do |cs|
  	cs.source_files = 'Roy/Classes/Core/*.{swift}'
    cs.frameworks = 'Foundation'
    cs.dependency 'GRDB.swift'
  end
  s.subspec 'UI' do |cs|
      cs.source_files = 'Roy/Classes/UIKit/*.{swift}'
      cs.dependency 'Roy/Core'
      cs.frameworks = 'UIKit'
  end
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
