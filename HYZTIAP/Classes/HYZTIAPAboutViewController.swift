
import UIKit
import SwiftyFitsize
import SnapKit
import YSExtensions

public class HYZTIAPAboutViewController: UIViewController {
    
    @objc public let imageView = UIImageView()
    
    @objc public let label = UILabel(text: "", font: .mediumSystemFont(ofSize: 16~), textColor: UIColor("333"), textAlignment: .center, backgroundColor: .clear)
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("#F5F6FA")
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8~
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(156~)
            make.size.equalTo(CGSize(width: 84, height: 84)~)
        }
        
        view.addSubview(label)
        label.numberOfLines = 0
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(14~)
            make.centerX.equalToSuperview()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc public static func aboutUsInfo() -> String {
        //应用程序信息
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return ""
        }
        //程序名称
        let appName = infoDictionary["CFBundleDisplayName"] as? String
        //主程序版本号
        let version = infoDictionary["CFBundleShortVersionString"] as? String
        return (appName ?? "") + "\nVersion " + (version ?? "1.0")
    }
    
}

public extension UIViewController {
    @objc public func pushAboutUs() {
        // 关于我们
        let vc = HYZTIAPAboutViewController()
        // 图片
        vc.imageView.image = UIImage(named: HYZTIAPConfig.shared.delegate?.logo ?? "")
        vc.label.text = HYZTIAPAboutViewController.aboutUsInfo()
        vc.title = "关于我们"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
