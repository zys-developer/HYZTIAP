
import UIKit

extension UIViewController {
    
    /// 弹出内购
    /// - Parameter actionHandler: 订阅后执行的闭包
    /// - Returns: 是否已订阅
    @discardableResult
    @objc public func isVip(actionHandler: @escaping () -> Void) -> Bool {
        if HYZTIAPViewModel.isVip {
            // 已订阅, 执行回调闭包
            actionHandler()
            return true
        } else {
            // 未订阅, 弹出内购页
            let ivc = HYZTIAPGuideViewController { [unowned self] in
                dismiss(animated: true) {
                    guard HYZTIAPViewModel.isVip else { return }
                    actionHandler()
                }
            }
            let nvc = UINavigationController(rootViewController: ivc)
            nvc.modalPresentationStyle = .fullScreen
            present(nvc, animated: true)
            return false
        }
    }
    
    /// 弹出内购
    /// - Parameters:
    ///   - shouldVip: 条件为true时才判断是否已订阅
    ///   - actionHandler: shouldVip为false或订阅后执行的闭包
    @objc public func isVip(shouldVip: Bool, actionHandler: @escaping () -> Void) {
        if shouldVip {
            isVip(actionHandler: actionHandler)
        } else {
            actionHandler()
        }
    }
    
    /// 弹出内购
    /// - Parameters:
    ///   - key: 判断的key
    ///   - times: 总次数
    ///   - actionHandler: 次数未超总次数或订阅后执行的闭包
    @objc public func isVip(for key: String, times: Int, actionHandler: @escaping () -> Void) {
        isVip(for: key, times: times, currentTimes: 1, actionHandler: actionHandler)
    }
    /// 弹出内购
    /// - Parameters:
    ///   - key: 判断的key
    ///   - times: 总次数
    ///   - currentTimes: 当前累加的次数
    ///   - actionHandler: 次数未超总次数或订阅后执行的闭包
    @objc public func isVip(for key: String, times: Int, currentTimes: Int, actionHandler: @escaping () -> Void) {
        let newTimes = UserDefaults.standard.integer(forKey: key) + currentTimes
        if newTimes > times {
            isVip(actionHandler: actionHandler)
        } else {
            UserDefaults.standard.set(newTimes, forKey: key)
            actionHandler()
        }
    }
    /// 弹出内购
    /// - Parameters:
    ///   - key: 判断的key
    ///   - times: 总次数
    ///   - days: 判断间隔天数
    ///   - actionHandler: 次数未超总次数或订阅后执行的闭包
    @objc public func isVip(for key: String, times: Int, during days: Int, actionHandler: @escaping () -> Void) {
        // 时间格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        // 当前时间
        let nowDate = Date()
        let nowDateStr = formatter.string(from: nowDate)
        let ud = UserDefaults.standard
        // 次数
        let newTimes: Int
        // 上次的日期
        let oldDate = formatter.date(from: ud.string(forKey: "\(key)-date") ?? "20201212") ?? nowDate
        // 上个周期的结束时间
        let endDate = oldDate.addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
        if nowDate > endDate {
            // 新的周期
            newTimes = 1
            ud.set(nowDateStr, forKey: "\(key)-date")
        } else {
            // 一个周期内
            newTimes = ud.integer(forKey: "\(key)-times") + 1
        }
        if newTimes > times {
            isVip(actionHandler: actionHandler)
        } else {
            ud.set(newTimes, forKey: "\(key)-times")
            actionHandler()
        }
    }
}
