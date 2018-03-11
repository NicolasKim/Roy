
Pod::Spec.new do |s|

  s.name             = 'Roy'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Roy.'
  s.module_name  = 'Roy'
  s.summary      = "Just testing"
  s.description      = <<-DESC
    Add long description of the pod here.
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
  end
  s.subspec 'UI' do |cs|
      cs.source_files = 'Roy/Classes/UIKit/*.{swift}'
      cs.dependency 'Roy/Core'
      cs.frameworks = 'UIKit'
  end
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
