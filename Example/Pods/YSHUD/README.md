## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

YSHUD is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YSHUD'
```

如果你的项目中引用了MBProgressHUD, 执行pod install时可能会报错, 可以按照错误提示把MBProgressHUD转为静态库, 在Podfile中做如下修改:
```ruby
pod 'MBProgressHUD', :modular_headers => true
```
或者把所有pod项都转为静态库, 在Podfile最顶部添加:
```ruby
use_modular_headers!
```
