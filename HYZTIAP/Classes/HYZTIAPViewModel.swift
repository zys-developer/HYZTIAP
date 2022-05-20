
import Foundation
import StoreKit
import RxSwift
import RxCocoa
import Alamofire
import MoyaHandyJSON

public class HYZTIAPViewModel: NSObject {
    
    /// 已订阅自动续订会员
    @objc public static var isVVip: Bool {
        let time = UserDefaults.standard.double(forKey: "isVVipKey")
        let now = Date.init().timeIntervalSince1970
        return time > now
    }
    
    /// 已订阅普通会员
    @objc public static var isVip: Bool {
        let time = UserDefaults.standard.double(forKey: "isVipKey")
        let now = Date.init().timeIntervalSince1970
        print(time, now)
        return time > now
    }
    
    static func becomeObserver() {
        SKPaymentQueue.default().add(shared)
    }
    
    private let disposeBag = DisposeBag()
    
    /// 请求商品
    static let productRequest = PublishSubject<String>()
    ///  恢复购买
    static let restore = PublishSubject<Void>()
    /// 完成订单
    private let completeTransaction = PublishSubject<SKPaymentTransaction>()
    /// 成功
    static let success = PublishSubject<String?>()
    /// 失败
    static let failure = PublishSubject<String?>()
    
    // 网络监听
    private let nrm = NetworkReachabilityManager()
    static let reachability = BehaviorRelay(value: true)
    /// 引导页模型
    static let guideModel = BehaviorRelay<HYZTIAPModel?>(value: nil)
    /// 内购页模型
    static let mineModel = BehaviorRelay<HYZTIAPModel?>(value: nil)
    
    private static let shared = HYZTIAPViewModel()
    private override init() {
        super.init()
        
        // 开始网络监听
        nrm?.startListening(onUpdatePerforming: { [weak self] status in
            switch status {
            case .reachable:
                HYZTIAPViewModel.reachability.accept(true)
                guard let `self` = self else { return }
                // 引导页模型数组
                iapProvider.rx.request(.guide)
                    .mapObject(HYZTIAPModel.self, designatedPath: "data")
                    .retry(100)
                    .subscribe { model in
                        HYZTIAPViewModel.guideModel.accept(model)
                    } onError: { _ in }
                    .disposed(by: self.disposeBag)
                // 内购页模型数组
                iapProvider.rx.request(.mine)
                    .mapObject(HYZTIAPModel.self, designatedPath: "data")
                    .retry(100)
                    .subscribe { model in
                        HYZTIAPViewModel.mineModel.accept(model)
                    } onError: { _ in }
                    .disposed(by: self.disposeBag)
            default:
                HYZTIAPViewModel.reachability.accept(false)
            }
        })
        
        // 请求商品
        HYZTIAPViewModel.productRequest
            .subscribe(onNext: { [unowned self] id in
                guard nrm?.isReachable == true else {
                    HYZTIAPViewModel.failure.onNext("当前没连接网络")
                    return
                }
                guard SKPaymentQueue.canMakePayments() else {
                    HYZTIAPViewModel.failure.onNext("当前设备不支持订阅")
                    return
                }
                let set: Set<String> = [id]
                let request = SKProductsRequest(productIdentifiers: set)
                request.delegate = self
                request.start()
            })
            .disposed(by: disposeBag)
        
        // 恢复购买
        HYZTIAPViewModel.restore
            .subscribe(onNext: {
                SKPaymentQueue.default().restoreCompletedTransactions()
                print("恢复订单")
            })
            .disposed(by: disposeBag)
        
        // 完成订单
        completeTransaction
            // 0.5秒内的多个订单,只验证最后一个
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] transaction in
                // 凭据路径
                guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
                    // 没有凭证
                    HYZTIAPViewModel.failure.onNext(transaction.transactionState == .restored ? "恢复失败" : "订阅失败")
                    return
                }
                // 从沙盒中获取到购买凭据
                do {
                    let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                    let receiptString = receiptData.base64EncodedString(options: [])
                    let param = ["receipt-data": receiptString, "password": HYZTIAPConfig.shared.delegate?.password ?? ""]
                    verifyReceipt(url: "https://buy.itunes.apple.com/verifyReceipt", param: param, isRestored: transaction.transactionState == .restored)
                } catch {
                    HYZTIAPViewModel.failure.onNext(transaction.transactionState == .restored ? "恢复失败" : "订阅失败")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func verifyReceipt(url: String, param: [String: Any], isRestored: Bool) {
        print("支付完成, 开始校验, 校验地址: \(url)")
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.timeoutInterval = 120
        request.cachePolicy = .useProtocolCachePolicy
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil else {
                HYZTIAPViewModel.failure.onNext(isRestored ? "恢复失败" : "订阅失败")
                return
            }
            let json = String(data: data!, encoding: .utf8)
            let receiptResponse = HYZTIAPReceiptResponse.deserialize(from: json)
            if receiptResponse?.status == 0 {
                let time: Double
                var expires_date_ms: Double = 0
                for info in receiptResponse?.latest_receipt_info ?? [] {
                    if let ms = info.expires_date_ms {
                        expires_date_ms = max(expires_date_ms, ms)
                    }
                }
                time = expires_date_ms / 1000
                // 当前时间
                let now = Date.init().timeIntervalSince1970
                if time < now {
                    HYZTIAPViewModel.failure.onNext(isRestored ? "没有可恢复的订阅" : nil)
                } else {
                    UserDefaults.standard.set(time, forKey: "isVVipKey")
                    UserDefaults.standard.set(time, forKey: "isVipKey")
                    HYZTIAPViewModel.success.onNext(isRestored ? "恢复成功" : "订阅成功")
                }
            } else if receiptResponse?.status == 21007 {
                self?.verifyReceipt(url: "https://sandbox.itunes.apple.com/verifyReceipt", param: param, isRestored: isRestored)
            } else {
                HYZTIAPViewModel.failure.onNext(isRestored ? "恢复失败" : "订阅失败")
            }
        }.resume()
    }
}

extension HYZTIAPViewModel: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard response.products.count > 0 else {
            HYZTIAPViewModel.failure.onNext("没有可订阅的产品")
            return
        }
        let payment = SKPayment(product: response.products.first!)
        SKPaymentQueue.default().add(payment)
        print("添加到商品队列")
    }
}

extension HYZTIAPViewModel: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // 遍历交易列表
        for tran in transactions {
            switch tran.transactionState {
            case .purchased, .restored:
                // 交易完成或恢复购买
                completeTransaction.onNext(tran)
                // 结束交易
                queue.finishTransaction(tran)
            case .failed:
                // 失败
                // 发送通知
                HYZTIAPViewModel.failure.onNext(nil)
                // 结束交易
                queue.finishTransaction(tran)
            default:
                break
            }
        }
    }
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions.count == 0 {
            // 没有可恢复的订阅
            HYZTIAPViewModel.failure.onNext("没有可恢复的订阅")
        }
    }
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // 恢复失败
        HYZTIAPViewModel.failure.onNext("恢复失败")
    }
}
