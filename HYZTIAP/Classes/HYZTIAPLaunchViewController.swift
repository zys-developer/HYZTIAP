
import UIKit
import SnapKit
import RxSwift

public class HYZTIAPLaunchViewController: UIViewController {
    
    static let didLaunchGuideKey = "didLaunchGuideKey"
    
    let disposeBag = DisposeBag()
    let config = HYZTIAPConfig.shared.delegate!
    let finishLaunching: () -> Void
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // logo和AppName
        logo()
        // 网络监听
        networkReachability()
    }
    
    func logo() {
        let stackView = UIStackView()
        // 布局方向
        stackView.axis = .vertical
        // 垂直于布局方向的对齐方式
        stackView.alignment = .center
        // 布局方向上的填充方式
        stackView.distribution = .equalSpacing
        // 间隔
        stackView.spacing = 12
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-config.logoBottom)
        }
        
        // logo
        let logo = UIImageView(config.logo)
        stackView.addArrangedSubview(logo)
        logo.snp.makeConstraints { make in
            make.width.equalTo(config.logoWidth)
            make.height.equalTo(config.logoHeight)
        }
        
        // appName
        if let infoDictionary = Bundle.main.infoDictionary, let appName = infoDictionary["CFBundleDisplayName"] as? String {
            let appNameLabel = UILabel(text: appName, font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center, backgroundColor: nil)
            stackView.addArrangedSubview(appNameLabel)
            appNameLabel.isHidden = true
        }
    }
    
    func networkReachability() {
        let stackView = UIStackView()
        stackView.isHidden = true
        // 布局方向
        stackView.axis = .vertical
        // 垂直于布局方向的对齐方式
        stackView.alignment = .center
        // 布局方向上的填充方式
        stackView.distribution = .equalSpacing
        // 间隔
        stackView.spacing = 30
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.85)
        }
        
        // 图片
        let image = UIImageView(config.noNetworkImage)
        stackView.addArrangedSubview(image)
        
        // 提示文字
        let tips = UILabel(text: config.noNetworkText, font: config.noNetworkTextFont, textColor: config.noNetworkTextColor, textAlignment: .center, backgroundColor: nil)
        stackView.addArrangedSubview(tips)
        
        // 取消按钮
        let cancelBtn = UIButton(title: config.noNetworkBtnTitle, textColor: config.noNetworkBtnTitleColor, font: config.noNetworkBtnTitleFont, backgroundColor: config.noNetworkBtnBgColor)
        cancelBtn.layer.cornerRadius = 24
        stackView.addArrangedSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.width.equalTo(248)
            make.height.equalTo(48)
        }
        cancelBtn.rx.tap
            .subscribe(onNext: finishLaunching)
            .disposed(by: disposeBag)
        
        HYZTIAPViewModel.reachability
            .bind(to: stackView.rx.isHidden)
            .disposed(by: disposeBag)
        HYZTIAPViewModel.guideModel
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.finishLaunching()
            })
            .disposed(by: disposeBag)
    }
    
    @objc public static func launch(on window: UIWindow?, rootViewController: UIViewController, configDelegate: Any, showXieyi: @escaping (UIViewController) -> Bool) {
        // 监听订阅订单
        HYZTIAPViewModel.becomeObserver()
        guard let window = window, let delegate = configDelegate as? HYZTIAPConfigDelegate else {
            return
        }
        HYZTIAPConfig.shared.delegate = delegate
        window.makeKeyAndVisible()
        // 启动页
        let launchVC = HYZTIAPLaunchViewController {
            if UserDefaults.standard.bool(forKey: didLaunchGuideKey) {
                // 已经加载过引导页
                window.rootViewController = rootViewController
            } else {
                // 引导页
                let ivc = HYZTIAPGuideViewController(purchaseType: .guide) {
                    window.rootViewController = rootViewController
                    UserDefaults.standard.set(true, forKey: didLaunchGuideKey)
                }
                window.rootViewController = UINavigationController(rootViewController: ivc)
                if showXieyi(ivc) {
                    // 隐私协议
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        HYZTIAPPrivacyViewController.showPrivacy(from: ivc)
                    }
                }
            }
        }
        window.rootViewController = launchVC
    }
    
    private init(finishLaunching: @escaping () -> Void) {
        self.finishLaunching = finishLaunching
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
