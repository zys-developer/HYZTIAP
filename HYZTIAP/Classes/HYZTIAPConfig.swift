

import UIKit

public struct HYZTIAPConfig {
    private init() {}
    public static var shared = HYZTIAPConfig()
    public var delegate: HYZTIAPConfigDelegate?
}

public protocol HYZTIAPConfigDelegate {
    // MARK: 视图控制器的配置
    /// 背景色
    var vcBgColor: UIColor { get }
    /// 图片名
    var vcImageName: String? { get }
    /// 图片位置大小
    var vcImageFrame: CGRect? { get }
    
    // MARK: 分页的配置
    /// 图片名前缀
    var imagePrefix: String { get }
    /// 图片位置
    var imageFrames: [CGRect] { get }
    /// 文字top
    var textTop: CGFloat { get }
    /// 文字间距
    var textSpacing: CGFloat { get }
    /// 大文字字体
    var bigTextFont: UIFont { get }
    /// 小文字字体
    var smallTextFont: UIFont { get }
    /// 大文字颜色
    var bigTextColor: UIColor { get }
    /// 小文字颜色
    var smallTextColor: UIColor { get }
    /// 按钮文字字体
    var btnFont: UIFont { get }
    /// 按钮顶部距离
    var btnTop: CGFloat { get }
    /// 按钮宽
    var btnWidth: CGFloat { get }
    /// 按钮高
    var btnHeight: CGFloat { get }
    /// 按钮圆角半径
    var btnCornerRadius: CGFloat { get }
    /// 按钮图片名
    var btnImageName: String? { get }
    /// 按钮文字颜色
    var btnTextColor: UIColor { get }
    /// 按钮背景色
    var btnBackgroundColor: UIColor? { get }
    
    // MARK: 引导页的配置
    /// 文字
    var texts: [(bigText: String, smallText: String)] { get }
    
    // MARK: 内购页的配置
    var closeBtnTop: CGFloat { get }
    var closeBtnLeading: CGFloat { get }
    /// 文字
    var text: String { get }
    /// 按钮间距
    var btnSpacing: CGFloat { get }
    /// 说明文字颜色
    var tipsColor: UIColor { get }
    /// 说明文字字体
    var tipsFont: UIFont { get }
    /// 说明文字top
    var tipsTop: CGFloat { get }
    /// 说明文字宽
    var tipsWidth: CGFloat { get }
    /// 底部按钮文字字体
    var bottomBtnFont: UIFont { get }
    /// 底部按钮文字颜色
    var bottomBtnTextColor: UIColor { get }
    /// 底部按钮top
    var bottomBtnTop: CGFloat { get }
    /// 底部按钮间距
    var bottomBtnSpacing: CGFloat { get }
    
    // MARK: 启动页的配置
    /// logo图片名
    var logo: String { get }
    /// logo宽
    var logoWidth: CGFloat { get }
    /// logo搞
    var logoHeight: CGFloat { get }
    /// logo底部间距
    var logoBottom: CGFloat { get }
    /// 断网图片名
    var noNetworkImage: String { get }
    /// 断网提示文字
    var noNetworkText: String { get }
    /// 断网提示文字颜色
    var noNetworkTextColor: UIColor { get }
    /// 断网提示文字字体
    var noNetworkTextFont: UIFont { get }
    /// 进入首页按钮文字
    var noNetworkBtnTitle: String { get }
    /// 进入首页按钮文字颜色
    var noNetworkBtnTitleColor: UIColor { get }
    /// 进入首页按钮文字颜色
    var noNetworkBtnTitleFont: UIFont { get }
    /// 进入首页按钮背景色
    var noNetworkBtnBgColor: UIColor { get }
    
    // MARK: 接口的配置
    /// 接口地址
    var host: String { get }
    /// 隐私协议
    var ysxy: String { get }
    /// 使用条款
    var sytk: String { get }
    /// 引导页
    var guide: String { get }
    /// 设置页
    var mine: String { get }
    /// 按钮上边的文字
    var messageMapper: String? { get }
    /// 商品列表
    var productListMapper: String? { get }
    /// 商品id
    var productIdMapper: String? { get }
    /// 按钮文字
    var textMapper: String? { get }
    
    // MARK: 内购秘钥
    var password: String { get }
}

public extension HYZTIAPConfigDelegate {
    // MARK: 视图控制器的配置
    /// 图片名
    var vcImageName: String? { nil }
    /// 图片位置大小
    var vcImageFrame: CGRect? { nil }
    
    // MARK: 分页的配置
    /// 图片名前缀
    var imagePrefix: String { "g_" }
    /// 小文字字体
    var smallTextFont: UIFont { .boldSystemFont(ofSize: 16) }
    /// 按钮文字字体
    var btnFont: UIFont { .boldSystemFont(ofSize: 18) }
    /// 按钮图片名
    var btnImageName: String? { nil }
    
    // MARK: 内购页的配置
    /// 按钮间距
    var btnSpacing: CGFloat { 12 }
    
    // MARK: 启动页的配置
    /// logo图片名
    var logo: String { "aboutUs" }
    /// logo宽
    var logoWidth: CGFloat { 80 }
    /// logo搞
    var logoHeight: CGFloat { 80 }
    /// logo底部间距
    var logoBottom: CGFloat { 30 }
    /// 断网图片名
    var noNetworkImage: String { "暂无网络" }
    /// 断网提示文字
    var noNetworkText: String { "网络获取失败" }
    /// 断网提示文字颜色
    var noNetworkTextColor: UIColor { .black }
    /// 断网提示文字字体
    var noNetworkTextFont: UIFont { .systemFont(ofSize: 14) }
    /// 进入首页按钮文字
    var noNetworkBtnTitle: String { "确定" }
    /// 进入首页按钮文字颜色
    var noNetworkBtnTitleColor: UIColor { #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) }
    /// 进入首页按钮文字颜色
    var noNetworkBtnTitleFont: UIFont { .systemFont(ofSize: 16) }
    /// 进入首页按钮背景色
    var noNetworkBtnBgColor: UIColor { #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) }
    
    // MARK: 接口的配置
    /// 按钮上边的文字
    var messageMapper: String? { nil }
    /// 商品列表
    var productListMapper: String? { nil }
    /// 商品id
    var productIdMapper: String? { nil }
    /// 按钮文字
    var textMapper: String? { nil }
}
