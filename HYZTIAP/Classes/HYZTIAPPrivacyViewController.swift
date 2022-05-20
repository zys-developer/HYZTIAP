
import UIKit
import SnapKit
import RxSwift
import ActiveLabel
import WebKit
import YSHUD
import MoyaHandyJSON

class HYZTIAPPrivacyViewController: UIViewController {
    
    static let key = "5p2o5LmU5bCx5piv5aS054yq"
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        navigationItem.backButtonTitle = ""
        
        // 背景
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(420)
            make.center.equalToSuperview()
        }
        
        // 标题
        let label = UILabel(text: "隐私协议/使用条款", font: .boldSystemFont(ofSize: 18), textColor: .black, textAlignment: .center, backgroundColor: nil)
        bgView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }

        // 同意/不同意按钮
        for i in 0...1 {
            let btn = UIButton(title: ["不同意并拒绝", "同意并进入"][i], textColor: i == 0 ? .hex("#999999") : .white, font: i == 0 ? .systemFont(ofSize: 14) : .systemFont(ofSize: 16), backgroundColor: i == 0 ? .clear : #colorLiteral(red: 0.03921568627, green: 0.6470588235, blue: 1, alpha: 1))
            bgView.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.bottom.equalTo(-7 - CGFloat(i) * 45)
                make.centerX.equalToSuperview()
                make.width.equalTo(180)
                make.height.equalTo(42)
            }
            btn.layer.cornerRadius = 6
            btn.rx.tap.subscribe(onNext: { [unowned self] in
                switch i {
                case 0:
                    exit(0)
                case 1:
                    dismiss(animated: false)
                    UserDefaults.standard.set(true, forKey: HYZTIAPPrivacyViewController.key)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        }
        
        let contentLabel = ActiveLabel()
        var customTypes = [ActiveType]()
        for highlight in ["《隐私协议》", "《使用条款》"] {
            let customType = ActiveType.custom(pattern: highlight)
            contentLabel.enabledTypes.append(customType)
            customTypes.append(customType)
        }
        contentLabel.customize { contentLabel in
            contentLabel.text = "非常感谢您使用我们的应用程序！我们竭诚为您服务！\n\n在使用应用程序之前，你有权而且需要去了解我们的隐私政策及使用条款等内容，这样可以更好的保护您的隐私以及清楚我们到底使用了哪些数据。\n\n你需要阅读《隐私协议》和《使用条款》，如果您同意我们将继续为您服务；如果您拒绝，请点击下方拒绝按钮并退出。"
            contentLabel.numberOfLines = 0
            contentLabel.minimumLineHeight = 21
            contentLabel.font = .systemFont(ofSize: 15)
            contentLabel.textColor = .black
            for (i, customType) in customTypes.enumerated() {
                contentLabel.customColor[customType] = #colorLiteral(red: 0.03921568627, green: 0.6470588235, blue: 1, alpha: 1)
                contentLabel.customSelectedColor[customType] = #colorLiteral(red: 0.03921568627, green: 0.6470588235, blue: 1, alpha: 1)
                contentLabel.handleCustomTap(for: customType) { [unowned self] _ in
                    pushXieYi(index: i)
                }
            }
        }
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
            make.centerY.equalToSuperview().offset(-20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    static func showPrivacy(from viewController: UIViewController) {
        let notShow = UserDefaults.standard.bool(forKey: key) != true
        guard notShow else { return }
        let nvc = UINavigationController(rootViewController: HYZTIAPPrivacyViewController())
        nvc.modalPresentationStyle = .overFullScreen
        viewController.present(nvc, animated: false)
    }
    
}

public class HYZTIAPWebViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var url: Any? {
        didSet {
            loadUrl()
        }
    }
    
    @objc public let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func loadUrl() {
        if let urlString = url as? String {
            if let newUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let urlUrl = URL(string: newUrl) {
                    webView.load(URLRequest(url: urlUrl))
                }
            }
        } else if let urlUrl = url as? URL {
            webView.load(URLRequest(url: urlUrl))
        } else if let urlRequest = url as? URLRequest {
            webView.load(urlRequest)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIViewController {
    @objc public func pushXieYi(index: Int) {
        let vc = HYZTIAPWebViewController()
        let i = index % 2
        vc.title = ["隐私协议", "使用条款"][i]
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        HUD.showLoading()
        let request = iapProvider.rx.request([HYZTIAPApi.ysxy, .sytk][i])
        if HYZTIAPApi.ysxy.path == HYZTIAPApi.sytk.path {
            request
                .mapArray(HYZTIAPXieYiModel.self, designatedPath: "data")
                .subscribe { models in
                    HUD.hide()
                    vc.webView.loadHTMLString(models[i].content ?? "", baseURL: nil)
                } onError: { _ in
                    HUD.hide()
                }
                .disposed(by: vc.disposeBag)
        } else {
            request
                .mapObject(HYZTIAPXieYiModel.self, designatedPath: "data")
                .subscribe { model in
                    HUD.hide()
                    vc.webView.loadHTMLString(model.content ?? "", baseURL: nil)
                } onError: { _ in
                    HUD.hide()
                }
                .disposed(by: vc.disposeBag)
        }
    }
}
