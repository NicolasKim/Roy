#
# Be sure to run `pod lib lint Roy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

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
  s.author           = { 'jinqiucheng1006@live.cn'}
  s.source           = { :git => 'https://github.com/NicolasKim/Roy.git', :branch => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Roy/Classes/*.{swift}'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.frameworks = 'UIKit', 'Foundation'

end
