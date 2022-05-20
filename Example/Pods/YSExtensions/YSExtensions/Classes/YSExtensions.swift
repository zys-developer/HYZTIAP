
import UIKit

extension UIFont {
    
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func ultraLightSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .ultraLight)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func thinSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .thin)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func lightSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func regularSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func mediumSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func semiboldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func heavySystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .heavy)
    }
    /// 创建字体
    /// - Parameter fontSize: 字号
    /// - Returns: 字体
    @objc public class func blackSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .black)
    }
    
}

extension UIColor {
    /// 根据颜色字符串初始化UIColor
    /// - Parameters:
    ///   - color: 16进制颜色字符串
    ///   - alpha: 透明度, 默认1(不透明)
    @objc public convenience init(_ color: String, _ alpha: CGFloat = 1) {
        var colorString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        // 去掉前缀
        while colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        while colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }
        // 取值区间
        var rang = NSRange()
        rang.location = 0
        rang.length = colorString.count / 3
        
        let rString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let gString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let bString = (colorString as NSString).substring(with: rang)
        
        var r:UInt64 = 0, g:UInt64 = 0,b: UInt64 = 0
        
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        let denominator = pow(Double(16), Double(rang.length)) - 1
        self.init(red: CGFloat(r) / CGFloat(denominator), green: CGFloat(g) / CGFloat(denominator), blue: CGFloat(b) / CGFloat(denominator), alpha: alpha)
    }
    
    /// 根据颜色字符串初始化UIColor
    /// - Parameter hex: 16进制颜色字符串
    /// - Returns: 颜色
    @objc public class func hex(_ hex: String) -> UIColor {
        UIColor(hex)
    }
    
    /// 根据颜色字符串初始化UIColor
    /// - Parameter hexa: 16进制颜色字符串+透明度
    /// - Returns: 颜色
    @objc public class func hexa(_ hexa: String) -> UIColor {
        var colorString = hexa.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        // 去掉前缀
        while colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        while colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }
        // 取值区间
        var rang = NSRange()
        rang.location = 0
        rang.length = colorString.count / 4
        
        let rString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let gString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let bString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let aString = (colorString as NSString).substring(with: rang)
        
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0, alpha: UInt64 = 0
        
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        Scanner(string: aString).scanHexInt64(&alpha)
        let denominator = pow(Double(16), Double(rang.length)) - 1
        return UIColor.init(red: CGFloat(r) / CGFloat(denominator), green: CGFloat(g) / CGFloat(denominator), blue: CGFloat(b) / CGFloat(denominator), alpha: CGFloat(alpha) / CGFloat(denominator))
    }
    
    /// 根据颜色字符串初始化UIColor
    /// - Parameter ahex: 16进制透明度+颜色字符串
    /// - Returns: 颜色
    @objc public class func ahex(_ ahex: String) -> UIColor {
        var colorString = ahex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        // 去掉前缀
        while colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        while colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }
        // 取值区间
        var rang = NSRange()
        rang.location = 0
        rang.length = colorString.count / 4
        
        let aString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let rString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let gString = (colorString as NSString).substring(with: rang)
        rang.location += rang.length
        let bString = (colorString as NSString).substring(with: rang)
        
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0, alpha: UInt64 = 0
        
        Scanner(string: aString).scanHexInt64(&alpha)
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        let denominator = pow(Double(16), Double(rang.length)) - 1
        return UIColor.init(red: CGFloat(r) / CGFloat(denominator), green: CGFloat(g) / CGFloat(denominator), blue: CGFloat(b) / CGFloat(denominator), alpha: CGFloat(alpha) / CGFloat(denominator))
    }
    
    /// 根据三原色值+透明度初始化UIColor
    /// - Parameters:
    ///   - r: 红
    ///   - g: 绿
    ///   - b: 蓝
    ///   - a: 透明度
    /// - Returns: 颜色
    @objc public class func rgba(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1) -> UIColor {
        return self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    /// 根据三原色值+透明度初始化UIColor
    /// - Parameters:
    ///   - r: 红
    ///   - g: 绿
    ///   - b: 蓝
    ///   - a: 透明度
    /// - Returns: 颜色
    @objc public class func RGBA(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1) -> UIColor {
        return self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
}

extension UIButton {
    /// 初始化UIButton
    /// - Parameter title: 标题
    /// - Parameter textColor: 标题颜色
    /// - Parameter font: 标题字体
    /// - Parameter backgroundColor: 背景色
    @objc public convenience init(title: String?, textColor: UIColor?, font: UIFont, backgroundColor: UIColor? = .clear) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(textColor ?? .black, for: .normal)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor ?? .clear
        self.adjustsImageWhenHighlighted = false
    }
    
    /// 初始化UIButton
    /// - Parameter backgroundImage: 图片
    @objc public convenience init(bgImage: UIImage?) {
        self.init()
        self.adjustsImageWhenHighlighted = false
        self.setBackgroundImage(bgImage, for: UIControl.State.normal)
    }
    
    /// 初始化UIButton
    /// - Parameter name: 图片名
    @objc public convenience init(_ bgImageName: String) {
        self.init(bgImage: UIImage(named: bgImageName))
    }
    
    /// 初始化UIButton
    /// - Parameter normalImage: 图片
    @objc public convenience init(normalImage: UIImage?) {
        self.init()
        self.adjustsImageWhenHighlighted = false
        self.setImage(normalImage, for: UIControl.State.normal)
    }
    
    /// 初始化UIButton
    /// - Parameter name: 图片名
    @objc public convenience init(normalImageName: String) {
        self.init(normalImage: UIImage(named: normalImageName))
    }
}

extension UILabel {
    /// 初始化UILabel
    /// - Parameters:
    ///   - text: 文字
    ///   - font: 字体
    ///   - textColor: 文字颜色
    ///   - textAlignment: 对齐方式
    ///   - backgroundColor: 背景颜色
    @objc public convenience init(text: String?, font: UIFont, textColor: UIColor?, textAlignment: NSTextAlignment, backgroundColor: UIColor? = .clear) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor ?? .black
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor ?? .clear
    }
}

extension UIImageView {
    /// 初始化UIImageView
    /// - Parameters:
    ///   - imageName: 图片名
    ///   - frame: 位置大小
    @objc public convenience init(_ imageName: String?, frame: CGRect = .zero) {
        if let imageName = imageName {
            self.init(image: UIImage(named: imageName))
        } else {
            self.init()
        }
        self.frame = frame
    }
}

extension UITableView {
    /// 注册多种cell
    /// - Parameter classes: cell类的数组
    @objc public func registerCells(_ classes: [AnyClass]) {
        for cl in classes {
            register(cl, forCellReuseIdentifier: NSStringFromClass(cl))
        }
    }
    /// 注册多种头尾视图
    /// - Parameter classes: 头尾视图类的数组
    @objc public func registerHeaderFooters(_ classes: [AnyClass]) {
        for cl in classes {
            register(cl, forHeaderFooterViewReuseIdentifier: NSStringFromClass(cl))
        }
    }
}

extension UICollectionView {
    /// 注册多种cell
    /// - Parameter classes: cell类的数组
    @objc public func registerCells(_ classes: [AnyClass]) {
        for cl in classes {
            register(cl, forCellWithReuseIdentifier: NSStringFromClass(cl))
        }
    }
    /// 注册多种头视图
    /// - Parameter classes: 头视图类的数组
    @objc public func registerHeaders(_ classes: [AnyClass]) {
        for cl in classes {
            register(cl, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(cl))
        }
    }
    /// 注册多种尾视图
    /// - Parameter classes: 尾视图类的数组
    @objc public func registerFooters(_ classes: [AnyClass]) {
        for cl in classes {
            register(cl, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(cl))
        }
    }
}

extension UITextField {
    /// 初始化UITextField
    /// - Parameters:
    ///   - frame: 位置大小
    ///   - font: 字体
    ///   - textColor: 文字颜色
    ///   - placeholder: 占位符
    @objc public convenience init(frame: CGRect = .zero, font: UIFont, textColor: UIColor, placeholder: String?) {
        self.init()
        self.frame = frame
        self.font = font
        self.textColor = textColor
        self.placeholder = placeholder
    }
}

extension UIAlertController {
    /// 添加默认风格的行为
    /// - Parameters:
    ///   - title: 标题
    ///   - handler: 点击后的回调
    @objc public func addDefaultAction(title: String?, handler: ((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(title: title, style: .default, handler: handler)
        addAction(action)
    }
    /// 添加破坏风格的行为
    /// - Parameters:
    ///   - title: 标题
    ///   - handler: 点击后的回调
    @objc public func addDestructiveAction(title: String?, handler: ((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(title: title, style: .destructive, handler: handler)
        addAction(action)
    }
    /// 添加取消风格的行为
    /// - Parameters:
    ///   - title: 标题
    ///   - handler: 点击后的回调
    @objc public func addCancelAction(title: String? = "取消", handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(action)
    }
}

extension UIStackView {
    @objc public convenience init(axis: NSLayoutConstraint.Axis, alignment: Alignment = .center, distribution: Distribution = .equalSpacing, spacing: CGFloat) {
        self.init(axis: axis, alignment: alignment, distribution: distribution)
        self.spacing = spacing
    }
    @objc public convenience init(axis: NSLayoutConstraint.Axis, alignment: Alignment = .center, distribution: Distribution = .equalSpacing) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
    }
}
