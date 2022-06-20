#
# Be sure to run `pod lib lint HYZTIAP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYZTIAP'
  s.version          = '0.2.0'
  s.summary          = '鸿运众腾内购'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  鸿运众腾内购封装
                       DESC

  s.homepage         = 'https://github.com/zys-developer/HYZTIAP'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zys-developer' => 'zys_dev@163.com' }
  s.source           = { :git => 'https://github.com/zys-developer/HYZTIAP.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'HYZTIAP/Classes/**/*'
  s.dependency 'YSHUD'
  s.dependency 'SwiftyFitsize', '~> 1.4.0'
  s.dependency 'MoyaHandyJSON/RxSwift'
  s.dependency 'YSExtensions', '~> 0.1.4'
  s.dependency 'RxCocoa'
  s.dependency 'SnapKit'
  s.dependency 'ActiveLabel'
end
