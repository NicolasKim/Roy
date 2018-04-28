
Pod::Spec.new do |s|

  s.name             = 'Roy'
  s.version          = '0.0.2'
  s.summary          = '一个轻量组件化支持框架'
  s.module_name  = 'Roy'
  s.description      = <<-DESC
    empty
                       DESC
  s.platform     = :ios, "8.0"
  s.homepage         = 'https://github.com/NicolasKim'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'jinqiucheng1006@live.cn'
  s.source           = { :git => 'https://github.com/NicolasKim/Roy.git', :branch => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspecs = 'Core', 'Extension'
  s.subspec 'Core' do |cs|
  	cs.source_files = 'Roy/Classes/Core/*.{swift}'
    cs.dependency 'GRDB.swift'
    cs.dependency 'PromiseKit/CorePromise'
  end
  s.subspec 'Extension' do |cs|
      cs.source_files = 'Roy/Classes/Extension/*.{swift}'
      cs.dependency 'Roy/Core'
  end
  s.frameworks = 'Foundation','UIKit'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
