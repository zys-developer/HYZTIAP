
import UIKit
import RxSwift
import RxCocoa
import YSHUD
import SwiftyFitsize
import SnapKit

class HYZTIAPPurchasePage: UIView {
    
    let config = HYZTIAPConfig.shared.delegate!
    
    let disposeBag = DisposeBag()
    // 是否引导页
    let isGuide: Bool
    // 数据模型
    let model: BehaviorRelay<HYZTIAPModel?>
    // 购买按钮
    let productView = UIStackView()
    // 关闭按钮
    let closeBtn = UIButton("\(HYZTIAPConfig.shared.delegate?.imagePrefix ?? "g_")close")
    
    init(isGuide: Bool, pushXieYi: @escaping (Int) -> Void) {
        self.isGuide = isGuide
        self.model = isGuide ? HYZTIAPViewModel.guideModel : HYZTIAPViewModel.mineModel
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
            make.top.equalTo(config.textTop~)
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
            make.top.equalTo(config.btnTop~)
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
                    btn.layer.cornerRadius = self.config.btnCornerRadius~
                    self.productView.addArrangedSubview(btn)
                    btn.snp.makeConstraints { make in
                        make.width.equalTo(self.config.btnWidth~)
                        make.height.equalTo(self.config.btnHeight~)
                    }
                    // MARK: 点击按钮, 开始订阅
                    btn.rx.tap
                        .subscribe(onNext: {
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
            make.bottom.equalTo(60)
        }
        let btnTexts = ["隐私协议", "使用条款", "恢复购买"]
        for i in 0..<3 {
            let btn = UIButton(title: btnTexts[i], textColor: config.bottomBtnTextColor, font: config.bottomBtnFont~, backgroundColor: nil)
            stackView.addArrangedSubview(btn)
            btn.rx.tap
                .subscribe(onNext: {
                    if i < 2 {
                        pushXieYi(i)
                    } else {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
