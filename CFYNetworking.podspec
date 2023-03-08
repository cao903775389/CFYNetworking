#
# Be sure to run `pod lib lint CFYNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CFYNetworking'
  s.version          = '1.0.0'
  s.summary          = '网络库封装'
  s.description      = <<-DESC
网络库封装
                       DESC

  s.homepage         = 'https://github.com/cao903775389/CFYNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'caofengyang' => '17600122188@163.com' }
  s.source           = { :git => 'https://github.com/cao903775389/CFYNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CFYNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CFYNetworking' => ['CFYNetworking/Assets/*.png']
  # }

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.dependency 'AFNetworking', '~> 2.3'
end