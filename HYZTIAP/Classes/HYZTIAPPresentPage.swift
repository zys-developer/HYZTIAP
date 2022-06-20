//
//  HYZTIAPPresentPage.swift
//  HYZTIAP
//
//  Created by 张先生 on 2022/6/18.
//

import UIKit
import SnapKit
import SwiftyFitsize
import RxSwift
import YSHUD

public class HYZTIAPPresentPage: UIView {
    
    let disposeBag = DisposeBag()
    let closeBtn: UIButton
    public let scrollView = UIScrollView()
    public let bigLabel: UILabel
    public let smallLabel: UILabel
    public let confirmBtn: UIButton
    var shouldShake = true
    
    init(pushXieYi: @escaping (Int) -> Void) {
        let config = HYZTIAPConfig.shared.delegate!
        bigLabel = UILabel(text: config.text, font: config.p_bigTextFont!~, textColor: config.p_bigTextColor, textAlignment: .center, backgroundColor: nil)
        smallLabel = UILabel()
        let btn = UIButton(title: config.p_btnText, textColor: config.p_btnTextColor, font: config.p_btnTextFont!~, backgroundColor: config.p_btnBackgroundColor)
        confirmBtn = btn
        closeBtn = UIButton(title: "现在不", textColor: config.p_closeBtnColor, font: config.p_closeBtnFont!~)
        super.init(frame: .zero)
        
        backgroundColor = config.vcBgColor
        
        // 禁用自动调整布局
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.contentInsetAdjustmentBehavior = .never
        // 隐藏滚动条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-(config.p_btnTop! > config.bottomBtnTop ? config.p_btnTop! + config.p_btnHeight! + 20 : config.bottomBtnTop + 40)~)
        }
        
        // 图片
        let imageView = UIImageView("\(config.imagePrefix)3")
        scrollView.addSubview(imageView)
        let imageFrame = config.imageFrames[3]
        imageView.snp.makeConstraints { make in
            make.top.equalTo(imageFrame.origin.y~)
            make.leading.equalTo(imageFrame.origin.x~)
            make.size.equalTo(imageFrame.size~)
            make.trailing.equalToSuperview().offset((375 - imageFrame.origin.x - imageFrame.width)~)
        }
        imageView.frame = config.imageFrames[3]~
        
        scrollView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(config.closeBtnTop)
            make.leading.equalTo(config.closeBtnLeading)
        }
        
        // 大文字
        bigLabel.numberOfLines = 0
        scrollView.addSubview(bigLabel)
        bigLabel.snp.makeConstraints { make in
            make.top.equalTo((config.p_bigTextTop ?? 0)~)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(375~)
        }
        
        // 小文字
        smallLabel.numberOfLines = 0
        smallLabel.textAlignment = .left
        scrollView.addSubview(smallLabel)
        smallLabel.snp.makeConstraints { make in
            make.top.equalTo(bigLabel.snp.bottom).offset(config.textSpacing~)
            make.centerX.equalToSuperview()
            make.width.equalTo(config.p_smallTextWidth!)
        }
        let texts = config.p_smallText!
        let attStr = NSMutableAttributedString(string: (texts).joined(separator: ""))
        for i in 0..<texts.count {
            let range = (attStr.string as NSString).range(of: texts[i])
            attStr.addAttribute(.font, value: config.p_smallTextFont![i]~, range: range)
            attStr.addAttribute(.foregroundColor, value: config.p_smallTextColor![i], range: range)
        }
        smallLabel.attributedText = attStr
        
        // 提示文字
        let tipsLabel = UILabel(text: "带有免费试用期的订阅将自动续订为付费订阅，除非关闭自动订阅。在确认购买时，将向iTunes账户收取费用，订阅将自动续订，除非您在当前订阅器结束前至少24小时关闭自动续订。在当前订阅期结束前24小时内将向账户收取续订费用，并确认续订费用。用户可以管理订阅，购买后可前往用户账户设置", font: config.tipsFont~, textColor: config.tipsColor, textAlignment: .left, backgroundColor: nil)
        tipsLabel.numberOfLines = 0
        scrollView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(smallLabel.snp.bottom).offset(config.tipsTop~)
            make.centerX.equalToSuperview()
            make.width.equalTo(config.tipsWidth~)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 底部按钮
        let bottomBtnStackView = UIStackView()
        // 布局方向
        bottomBtnStackView.axis = .horizontal
        // 垂直于布局方向的对齐方式
        bottomBtnStackView.alignment = .center
        // 布局方向上的填充方式
        bottomBtnStackView.distribution = .equalSpacing
        // 间距
        bottomBtnStackView.spacing = config.bottomBtnSpacing
        addSubview(bottomBtnStackView)
        bottomBtnStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(config.bottomBtnTop~)
            make.centerX.equalToSuperview()
        }
        let btnTexts = ["隐私协议", "使用条款", "恢复购买"]
        for i in 0..<3 {
            let btn = UIButton(title: btnTexts[i], textColor: config.bottomBtnTextColor, font: config.bottomBtnFont~, backgroundColor: nil)
            bottomBtnStackView.addArrangedSubview(btn)
            btn.rx.tap
                .subscribe(onNext: { [unowned self] in
                    if i < 2 {
                        pushXieYi(i)
                    } else {
                        shouldShake = false
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
        
        if let btnImageName = config.btnImageName {
            btn.setBackgroundImage(UIImage(named: btnImageName), for: .normal)
        }
        btn.layer.cornerRadius = (config.p_btnCornerRadius ?? 0)~
        btn.layer.masksToBounds = true
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(config.p_btnWidth!~)
            make.height.equalTo(config.p_btnHeight!~)
            make.top.equalTo(scrollView.snp.bottom).offset(config.p_btnTop ?? 20)
        }
        // shake
        Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .filter { [unowned self] _ in shouldShake }
            .subscribe(onNext: { [weak self] _ in
                btn.shake()
            })
            .disposed(by: disposeBag)
        HYZTIAPViewModel.guideModel
            .subscribe(onNext: { model in
                if let text = model?.productList?.first?.text {
                    btn.setTitle(text, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        // MARK: 点击按钮, 开始订阅
        btn.rx.tap
            .subscribe(onNext: { [unowned self] in
                shouldShake = false
                HUD.showLoading("加载中...") { hud in
                    hud.backgroundView.style = .blur
                    hud.backgroundView.blurEffectStyle = .regular
                    hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                    hud.contentColor = .white
                }
                // 在VM中处理订阅逻辑
                HYZTIAPViewModel.productRequest.onNext(config.p_defaultId ?? "")
            })
            .disposed(by: self.disposeBag)
        
        Observable.merge(HYZTIAPViewModel.success, HYZTIAPViewModel.failure)
            .subscribe(onNext: { [unowned self] _ in
                shouldShake = true
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 抖动方向
///
/// - horizontal: 水平抖动
/// - vertical:   垂直抖动
fileprivate enum ZHYShakeDirection: Int {
    case horizontal
    case vertical
}

fileprivate extension UIView {
    
    /// ZHY 扩展UIView增加抖动方法
    ///
    /// - Parameters:
    ///   - direction:  抖动方向    默认水平方向
    ///   - times:      抖动次数    默认5次
    ///   - interval:   每次抖动时间 默认0.1秒
    ///   - offset:     抖动的偏移量 默认2个点
    ///   - completion: 抖动结束回调
    func shake(direction: ZHYShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, offset: CGFloat = 4, completion: (() -> Void)? = nil) {
        
        //移动视图动画（一次）
        UIView.animate(withDuration: interval, animations: {
            switch direction {
                case .horizontal:
                    self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
                case .vertical:
                    self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
            }
            
        }) { (complete) in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) in
                    completion?()
                })
            }
            
            //如果当前不是最后一次，则继续动画，偏移位置相反
            else {
                self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
            }
        }
    }
}
