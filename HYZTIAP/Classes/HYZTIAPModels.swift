

import HandyJSON

struct HYZTIAPReceiptResponse: HandyJSON {
    /** 响应状态码
     21000    App Store 不能读取你提供的JSON对象
     21002    receipt-data 域的数据有问题
     21003    receipt 无法通过验证
     21004    提供的 shared secret 不匹配你账号中的 shared secret
     21005    receipt 服务器当前不可用
     21006    receipt 合法, 但是订阅已过期. 服务器接收到这个状态码时, receipt 数据仍然会解码并一起发送
     21007    receipt 是 Sandbox receipt, 但却发送至生产系统的验证服务
     21008    receipt 是生产 receipt, 但却发送至 Sandbox 环境的验证服务
     */
    var status: Int?
    // 收据信息
    var receipt: HYZTIAPReceiptModel?
    // 最新收据的base64编码的字符串
    var latest_receipt: String?
    // 最新的收据信息列表
    var latest_receipt_info: [HYZTIAPReceiptInfo]?
    // 尝试续订的结果信息
    var pending_renewal_info: [Any]?
}

struct HYZTIAPReceiptModel: HandyJSON {
    var adam_id: Double?
    var app_item_id: Double?
    var download_id: Double?
    // 应用的版本号
    var application_version: Double?
    // 应用的BundleID
    var bundle_id: String?
    // 收据信息数组
    var in_app: [HYZTIAPReceiptInfo]?
    // 首次购买时的应用版本号
    var original_application_version: String?
    // 原始购买日期
    var original_purchase_date: String?
    var original_purchase_date_ms: String?
    var original_purchase_date_pst: String?
    // 收据创建时间，用于验证，避免本地时间有问题
    var receipt_creation_date: String?
    var receipt_creation_date_ms: Double?
    var receipt_creation_date_pst: String?
    // 收据类型 沙盒/生产
    var receipt_type: String?
    // 网络请求时间
    var request_date: String?
    var request_date_ms: String?
    var request_date_pst: String?
    // 版本外部标识符
    var version_external_identifier: String?
}

struct HYZTIAPReceiptInfo: HandyJSON {
    // 到期时间
    var expires_date: String?
    var expires_date_ms: Double?
    var expires_date_pst: String?
    // 是否介绍期, 优惠期
    var is_in_intro_offer_period: Bool?
    // 是否试用期
    var is_trial_period: Bool?
    // 原始购买日期
    var original_purchase_date: String?
    var original_purchase_date_ms: Double?
    var original_purchase_date_pst: String?
    // 原始交易订单号
    var original_transaction_id: Double?
    // 产品id
    var product_id: String?
    // 购买日期
    var purchase_date: String?
    var purchase_date_ms: Double?
    var purchase_date_pst: String?
    // 购买数量
    var quantity: Double?
    // 订单编号
    var transaction_id: Double?
    // 用于区分跨设备的购买事件，包括订阅续订事件
    var web_order_line_item_id: Double?
    // 取消交易的时间和原因
    var cancellation_date: String?
    var cancellation_reason: String?
    // 订阅组标识符
    var subscription_group_identifier: Double?
}

public struct HYZTIAPXieYiModel: HandyJSON {
    public var content: String?
    public init() {}
}

public struct HYZTIAPModel: HandyJSON {
    // 按钮上边的文字
    public var message: String?
    // 商品列表
    public var productList: [HYZTIAPProductModel]?
    public init() {}
}

public struct HYZTIAPProductModel: HandyJSON {
    // 商品id
    public var productId: String?
    // 按钮文字
    public var text: String?
    public init() {}
}

extension HYZTIAPModel {
    // 自定义序列化规则
    mutating public func mapping(mapper: HelpingMapper) {
        if let message = HYZTIAPConfig.shared.delegate?.messageMapper {
            mapper <<<
                self.message <-- message
        }
        if let productList = HYZTIAPConfig.shared.delegate?.productListMapper {
            mapper <<<
                self.productList <-- productList
        }
    }
}

extension HYZTIAPProductModel {
    // 自定义序列化规则
    mutating public func mapping(mapper: HelpingMapper) {
        if let productId = HYZTIAPConfig.shared.delegate?.productIdMapper {
            mapper <<<
                self.productId <-- productId
        }
        if let text = HYZTIAPConfig.shared.delegate?.textMapper {
            mapper <<<
                self.text <-- text
        }
    }
}
