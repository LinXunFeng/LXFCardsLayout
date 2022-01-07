#
# Be sure to run `pod lib lint LXFCardsLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LXFCardsLayout'
  s.version          = '0.0.1'
  s.summary          = 'A short description of LXFCardsLayout.'
  
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/林洵锋/LXFCardsLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LinXunFeng' => 'linxunfeng@yeah.net' }
  s.source           = { :git => 'https://github.com/LinXunFeng/LXFCardsLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'LXFCardsLayout/Classes/**/*'
  
end
