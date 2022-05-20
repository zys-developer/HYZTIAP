

import Foundation
import Moya

let iapProvider = MoyaProvider<HYZTIAPApi>()
enum HYZTIAPApi {
    case ysxy, sytk, guide, mine
}

extension HYZTIAPApi: TargetType {
    
    var baseURL: URL {
        URL(string: HYZTIAPConfig.shared.delegate?.host ?? "https://www.baidu.com")!
    }
    
    var path: String {
        switch self {
        // 隐私协议和用户条款
        case .ysxy:
            return HYZTIAPConfig.shared.delegate?.ysxy ?? ""
        case .sytk:
            return HYZTIAPConfig.shared.delegate?.sytk ?? ""
        case .guide:
            return HYZTIAPConfig.shared.delegate?.guide ?? ""
        case .mine:
            return HYZTIAPConfig.shared.delegate?.mine ?? ""
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        nil
    }
    
}
