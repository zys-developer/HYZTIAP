
import UIKit
import RxSwift
import RxCocoa
import YSHUD
import SwiftyFitsize
import SnapKit

class HYZTIAPPurchasePage: UIView {
    
    enum PurchaseType {
    case guide, mine, present
    }
    
    let config = HYZTIAPConfig.shared.delegate!
    
    let disposeBag = DisposeBag()
    // 类型
    let purchaseViewType: HYZTIAPConfig.PurchaseViewType
    // banner滚动
    var bannerScroll = true
    // 数据模型
    let model: BehaviorRelay<HYZTIAPModel?>
    // 购买按钮
    let productView = UIStackView()
    // 关闭按钮
    let closeBtn = UIButton("\(HYZTIAPConfig.shared.delegate?.imagePrefix ?? "g_")close")
    
    init(purchaseType: HYZTIAPPurchasePage.PurchaseType, pushXieYi: @escaping (Int) -> Void) {
        switch purchaseType {
        case .guide, .present where HYZTIAPConfig.shared.delegate?.purchaseType == .guide:
            self.model = HYZTIAPViewModel.guideModel
        default:
            self.model = HYZTIAPViewModel.mineModel
        }
        self.purchaseViewType = HYZTIAPConfig.shared.delegate!.purchaseViewType
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        let scrollView = UIScrollView()
        // 禁用自动调整布局
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.contentInsetAdjustmentBehavior = .never
        // 隐藏滚动条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        // 不回弹
        scrollView.bounces = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 图片
        let imageView = UIImageView("\(config.imagePrefix)3")
        scrollView.addSubview(imageView)
        imageView.frame = config.imageFrames[3]~
        
        // 大文字
        let bigLabel = UILabel(text: config.text, font: config.bigTextFont~, textColor: config.bigTextColor, textAlignment: .center, backgroundColor: nil)
        scrollView.addSubview(bigLabel)
        bigLabel.snp.makeConstraints { make in
            make.top.equalTo(config.textTop~ + (UIScreen.main.bounds.height - 667~) * 0.5)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(375~)
        }
        
        // 小文字
        let smallLabel = UILabel(text: nil, font: config.smallTextFont~, textColor: config.smallTextColor, textAlignment: .center, backgroundColor: nil)
        scrollView.addSubview(smallLabel)
        smallLabel.snp.makeConstraints { make in
            make.top.equalTo(bigLabel.snp.bottom).offset(config.textSpacing)
            make.centerX.equalToSuperview()
        }
        model
            .map({ $0?.message })
            .bind(to: smallLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 关闭按钮
        scrollView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(config.closeBtnTop)
            make.leading.equalTo(config.closeBtnLeading)
        }
        
        // 布局方向
        productView.axis = .vertical
        // 垂直于布局方向的对齐方式
        productView.alignment = .center
        // 布局方向上的填充方式
        productView.distribution = .equalSpacing
        // 间隔
        productView.spacing = config.btnSpacing~
        scrollView.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.top.equalTo(config.btnTop~ + (UIScreen.main.bounds.height - 667~) * 0.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(config.btnWidth~)
        }
        
        // 提示文字
        let tipsLabel = UILabel(text: "带有免费试用期的订阅将自动续订为付费订阅，除非关闭自动订阅。在确认购买时，将向iTunes账户收取费用，订阅将自动续订，除非您在当前订阅器结束前至少24小时关闭自动续订。在当前订阅期结束前24小时内将向账户收取续订费用，并确认续订费用。用户可以管理订阅，购买后可前往用户账户设置", font: config.tipsFont~, textColor: config.tipsColor, textAlignment: .left, backgroundColor: nil)
        tipsLabel.numberOfLines = 0
        scrollView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(productView.snp.bottom).offset(config.tipsTop~)
            make.centerX.equalToSuperview()
            make.width.equalTo(config.tipsWidth~)
        }
        
        // 创建商品按钮
        model
            // 非空过滤
            .filter({ $0 != nil })
            // 仅响应一次
            .take(1)
            .subscribe(onNext: { [weak self] model in
                guard let model = model, let `self` = self else {
                    return
                }
                for product in model.productList ?? [] {
                    let btn = UIButton(title: product.text, textColor: self.config.btnTextColor, font: self.config.btnFont~, backgroundColor: self.config.btnBackgroundColor)
                    if let btnImageName = self.config.btnImageName {
                        btn.setBackgroundImage(UIImage(named: btnImageName), for: .normal)
                    }
                    btn.layer.cornerRadius = self.config.btnCornerRadius~
                    btn.layer.masksToBounds = true
                    self.productView.addArrangedSubview(btn)
                    btn.snp.makeConstraints { make in
                        make.width.equalTo(self.config.btnWidth~)
                        make.height.equalTo(self.config.btnHeight~)
                    }
                    // MARK: 点击按钮, 开始订阅
                    btn.rx.tap
                        .subscribe(onNext: { [unowned self] in
                            self.bannerScroll = false
                            HUD.showLoading("加载中...") { hud in
                                hud.backgroundView.style = .blur
                                hud.backgroundView.blurEffectStyle = .regular
                                hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                                hud.contentColor = .white
                            }
                            // 在VM中处理订阅逻辑
                            HYZTIAPViewModel.productRequest.onNext(product.productId ?? "")
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        // 底部按钮
        let stackView = UIStackView()
        // 布局方向
        stackView.axis = .horizontal
        // 垂直于布局方向的对齐方式
        stackView.alignment = .center
        // 布局方向上的填充方式
        stackView.distribution = .equalSpacing
        // 间距
        stackView.spacing = config.bottomBtnSpacing
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(config.bottomBtnTop~)
            make.centerX.equalTo(tipsLabel)
            make.bottom.equalTo(-60)
        }
        let btnTexts = ["隐私协议", "使用条款", "恢复购买"]
        for i in 0..<3 {
            let btn = UIButton(title: btnTexts[i], textColor: config.bottomBtnTextColor, font: config.bottomBtnFont~, backgroundColor: nil)
            stackView.addArrangedSubview(btn)
            btn.rx.tap
                .subscribe(onNext: { [unowned self] in
                    if i < 2 {
                        pushXieYi(i)
                    } else {
                        bannerScroll = false
                        HUD.showLoading("恢复中...") { hud in
                            hud.backgroundView.style = .blur
                            hud.backgroundView.blurEffectStyle = .regular
                            hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                            hud.contentColor = .white
                        }
                        HYZTIAPViewModel.restore.onNext(())
                    }
                })
                .disposed(by: disposeBag)
        }
        
        config.customPurchase?(scrollView)
        
        guard purchaseViewType == .banner,
              let top = config.bannerTop,
              let width = config.bannerWidth,
              let height = config.bannerHeight,
              let titles = config.bannerTitles,
              let titleFont = config.bannerTitleFont,
              let titleColor = config.bannerTitleColor,
              let titleTop = config.bannerTitleTop,
              let contents = config.bannerContents,
              let contentFont = config.bannerContentFont,
              let contentColor = config.bannerContentColor,
              let contentTop = config.bannerContentTop,
              let imageNames = config.bannerImageNames,
              let imageTop = config.bannerImageTop,
              titles.count == contents.count,
              contents.count == imageNames.count else { return }
        let banner = UIScrollView()
        banner.isUserInteractionEnabled = false
        banner.showsHorizontalScrollIndicator = false
        scrollView.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.top.equalTo(top~)
            make.centerX.equalToSuperview()
            make.width.equalTo(width~)
            make.height.equalTo(height~)
        }
        let total = titles.count
        for i in 0...total {
            let view = UIView()
            banner.addSubview(view)
            let titleLabel = UILabel(text: titles[i % total], font: titleFont~, textColor: titleColor, textAlignment: .center)
            view.addSubview(titleLabel)
            let contentLabel = UILabel(text: contents[i % total], font: contentFont~, textColor: contentColor, textAlignment: .center)
            view.addSubview(contentLabel)
            let imageView = UIImageView(imageNames[i % total])
            view.addSubview(imageView)
            view.snp.makeConstraints { make in
                make.top.bottom.width.height.equalToSuperview()
                make.leading.equalTo(width * i~)
                if i == titles.count {
                    make.trailing.equalToSuperview()
                }
            }
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleTop)
                make.centerX.equalToSuperview()
            }
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(contentTop)
                make.centerX.equalToSuperview()
            }
            imageView.snp.makeConstraints { make in
                make.top.equalTo(imageTop)
                make.centerX.equalToSuperview()
                make.width.equalTo((imageView.image?.size.width ?? 0)~)
                make.height.equalTo((imageView.image?.size.height ?? 0)~)
            }
        }
        let pageControl: UIPageControl?
        if let top = config.bannerPageControlTop,
           let currentColor = config.bannerPageControlCurrentColor,
           let color = config.bannerPageControlColor {
            let pc = UIPageControl()
            pageControl = pc
            pc.numberOfPages = total
            pc.pageIndicatorTintColor = color
            pc.currentPageIndicatorTintColor = currentColor
            scrollView.addSubview(pc)
            pc.snp.makeConstraints { make in
                make.top.equalTo(top~)
                make.centerX.equalTo(banner)
            }
        } else {
            pageControl = nil
        }
        let index = BehaviorRelay(value: 0)
        index
            .subscribe(onNext: { i in
                if i == 1 {
                    banner.setContentOffset(.zero, animated: false)
                }
                banner.setContentOffset(CGPoint(x: width * i~, y: 0), animated: true)
                pageControl?.currentPage = i % 4
            })
            .disposed(by: disposeBag)
        Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .filter { [unowned self] _ in bannerScroll }
            .withLatestFrom(index)
            .map { $0 % titles.count + 1 }
            .bind(to: index)
            .disposed(by: disposeBag)
        HYZTIAPViewModel.success
            .subscribe(onNext: { [weak self] _ in
                self?.bannerScroll = true
            })
            .disposed(by: disposeBag)
        
        HYZTIAPViewModel.failure
            .subscribe(onNext: { [weak self] _ in
                self?.bannerScroll = true
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
