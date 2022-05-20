
import MBProgressHUD
import UIKit

@objc open class HUD: NSObject {
    
    /// 加载
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 展示的视图
    ///   - blur: 背景是否模糊处理
    ///   - effectStyle: 模糊效果的风格(仅在blur为true时有效)
    @objc open class func showLoading(_ text: String? = nil, on view: UIView? = nil, config handler: ((MBProgressHUD) -> Void)? = nil) {
        getMainThread {
            let onView: UIView?
            if let view = view {
                onView = view
            } else {
                onView = keyWindow()
            }
            guard let view = onView else { return }
            let hud: MBProgressHUD
            if let findHud = MBProgressHUD.forView(view) {
                hud = findHud
            } else {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
            }
            hud.label.text = text
            hud.removeFromSuperViewOnHide = true
            hud.defaultStyle()
            if let handler = handler {
                handler(hud)
            }
        }
    }
    @objc open class func showLoading(_ text: String? = nil, config handler: ((MBProgressHUD) -> Void)? = nil) {
        showLoading(text, on: nil, config: handler)
    }
    @objc open class func showLoading(_ text: String? = nil) {
        showLoading(text, on: nil, config: nil)
    }
    @objc open class func showLoading() {
        showLoading(nil, on: nil, config: nil)
    }
    
    /// 信息+文字
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - icon: 要显示的图标
    ///   - view: 展示的视图
    ///   - delay: 延迟隐藏的时间, ==0则不隐藏
    ///   - closure: 隐藏后的回调
    @objc open class func show(_ text: String?, icon: UIImage?, on view: UIView? = nil, hideAfter delay: TimeInterval = 1.5, config handler: ((MBProgressHUD) -> Void)? = nil, completed closure: (() -> Void)? = nil) {
        getMainThread {
            let onView: UIView?
            if let view = view {
                onView = view
            } else {
                onView = keyWindow()
            }
            guard let view = onView else { return }
            let hud: MBProgressHUD
            if let findHud = MBProgressHUD.forView(view) {
                hud = findHud
            } else {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
            }
            hud.mode = .customView
            hud.label.text = text
            if let icon = icon {
                hud.customView = UIImageView(image: icon)
            }
            hud.removeFromSuperViewOnHide = true
            hud.completionBlock = closure
            hud.defaultStyle()
            if let handler = handler {
                handler(hud)
            }
            if delay > 0 {
                hud.hide(animated: true, afterDelay: delay)
            }
        }
    }
    
    /// 信息
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 展示的视图
    ///   - delay: 延迟隐藏的时间, ==0则不隐藏
    ///   - closure: 隐藏后的回调
    @objc open class func showMessage(_ text: String?, on view: UIView? = nil, hideAfter delay: TimeInterval = 1.5, config handler: ((MBProgressHUD) -> Void)? = nil, completed closure: (() -> Void)? = nil) {
        show(text, icon: nil, on: view, hideAfter: delay, config: handler, completed: closure)
    }
    @objc open class func showMessage(_ text: String?) {
        showMessage(text, on: nil, hideAfter: 1.5, config: nil, completed: nil)
    }
    
    /// 成功
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 展示的视图
    ///   - delay: 延迟隐藏的时间, ==0则不隐藏
    ///   - closure: 隐藏后的回调
    @objc open class func showSucceed(_ text: String?, on view: UIView? = nil, hideAfter delay: TimeInterval = 1.5, config handler: ((MBProgressHUD) -> Void)? = nil, completed closure: (() -> Void)? = nil) {
        let image: UIImage?
        let mainBundle = Bundle(for: self)
        if let path = mainBundle.path(forResource: "YSHUD", ofType: "bundle"), let yshudBundle = Bundle(path: path), let iconPath = yshudBundle.path(forResource: "hud_succeed@2x", ofType: "png") {
            image = UIImage(contentsOfFile: iconPath)
        } else {
            image = nil
        }
        show(text, icon: image, on: view, hideAfter: delay, config: handler, completed: closure)
    }
    @objc open class func showSucceed(_ text: String?) {
        showSucceed(text, on: nil, hideAfter: 1.5, config: nil, completed: nil)
    }
    
    /// 警告
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 展示的视图
    ///   - delay: 延迟隐藏的时间, ==0则不隐藏
    ///   - closure: 隐藏后的回调
    @objc open class func showWarned(_ text: String?, on view: UIView? = nil, hideAfter delay: TimeInterval = 1.5, config handler: ((MBProgressHUD) -> Void)? = nil, completed closure: (() -> Void)? = nil) {
        let image: UIImage?
        let mainBundle = Bundle(for: self)
        if let path = mainBundle.path(forResource: "YSHUD", ofType: "bundle"), let yshudBundle = Bundle(path: path), let iconPath = yshudBundle.path(forResource: "hud_warned@2x", ofType: "png") {
            image = UIImage(contentsOfFile: iconPath)
        } else {
            image = nil
        }
        show(text, icon: image, on: view, hideAfter: delay, config: handler, completed: closure)
    }
    @objc open class func showWarned(_ text: String?) {
        showWarned(text, on: nil, hideAfter: 1.5, config: nil, completed: nil)
    }
    
    /// 失败
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 展示的视图
    ///   - delay: 延迟隐藏的时间, ==0则不隐藏
    ///   - closure: 隐藏后的回调
    @objc open class func showFailed(_ text: String?, on view: UIView? = nil, hideAfter delay: TimeInterval = 1.5, config handler: ((MBProgressHUD) -> Void)? = nil, completed closure: (() -> Void)? = nil) {
        let image: UIImage?
        let mainBundle = Bundle(for: self)
        if let path = mainBundle.path(forResource: "YSHUD", ofType: "bundle"), let yshudBundle = Bundle(path: path), let iconPath = yshudBundle.path(forResource: "hud_failed@2x", ofType: "png") {
            image = UIImage(contentsOfFile: iconPath)
        } else {
            image = nil
        }
        show(text, icon: image, on: view, hideAfter: delay, config: handler, completed: closure)
    }
    @objc open class func showFailed(_ text: String?) {
        showFailed(text, on: nil, hideAfter: 1.5, config: nil, completed: nil)
    }
    
    /// 进度
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - view: 展示的视图
    ///   - progress: 进度, 进度>=1后0.2秒隐藏
    @objc open class func showProgressRound(_ text: String?, on view: UIView? = nil, _ progress: Float, config handler: ((MBProgressHUD) -> Void)? = nil) {
        getMainThread {
            let onView: UIView?
            if let view = view {
                onView = view
            } else {
                onView = keyWindow()
            }
            guard let view = onView else { return }
            let hud: MBProgressHUD
            if let findHud = MBProgressHUD.forView(view) {
                hud = findHud
            } else {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
            }
            hud.mode = .annularDeterminate
            hud.label.text = text
            hud.removeFromSuperViewOnHide = true
            hud.progress = progress
            hud.defaultStyle()
            if let handler = handler {
                handler(hud)
            }
            if progress >= 1 {
                hud.hide(animated: true, afterDelay: 0.3)
            }
        }
    }
    @objc open class func showProgressRound(_ text: String?, _ progress: Float) {
        showProgressRound(text, on: nil, progress, config: nil)
    }
    
    /// 隐藏
    /// - Parameter view: 展示的视图
    @objc open class func hide(on view: UIView? = nil) {
        getMainThread {
            let onView: UIView?
            if let view = view {
                onView = view
            } else {
                onView = keyWindow()
            }
            guard let view = onView else { return }
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    @objc open class func hide() {
        hide(on: nil)
    }
    
    /// 在主线程执行
    /// - Parameter closure: 要执行的闭包
    private class func getMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    @objc class func keyWindow() -> UIView? {
        for window in UIApplication.shared.windows {
            if window.windowLevel == .normal {
                return window
            }
        }
        return UIApplication.shared.windows.last
    }
    
}

extension MBProgressHUD {
    
    fileprivate func defaultStyle() {
        bezelView.style = .solidColor
        bezelView.color = UIColor(white: 0, alpha: 0.7)
        contentColor = .white
    }
    
}
