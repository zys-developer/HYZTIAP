
import UIKit
import RxSwift
import RxCocoa
import YSHUD
import SwiftyFitsize

class HYZTIAPGuideViewController: UIViewController {
    
    // 是否引导页
    let isGuide: Bool
    // 控制器出栈后的操作
    let finished: () -> Void
    // 滚动视图
    let scrollView = UIScrollView()
    
    let config = HYZTIAPConfig.shared.delegate!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        background()
        // 分页
        pages()
        // 继续按钮
        if isGuide {
            nextBtn()
        }
        // 订阅
        subscribe()
    }
    
    func background() {
        view.backgroundColor = config.vcBgColor
        if let imageName = config.vcImageName {
            let imageView = UIImageView(imageName)
            view.addSubview(imageView)
            imageView.frame = config.vcImageFrame ?? .zero
        }
    }
    
    func pages() {
        
        scrollView.frame = view.bounds
        // 禁用自动调整布局
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.contentInsetAdjustmentBehavior = .never
        // 隐藏滚动条
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        // 分页
        scrollView.isPagingEnabled = true
        // 不回弹
        scrollView.bounces = false
        // 容器大小
        scrollView.contentSize = CGSize(width: view.bounds.width * (isGuide ? 4 : 1), height: view.bounds.height)
        view.addSubview(scrollView)
        
        // 内购页
        let iapPage = HYZTIAPPurchasePage(isGuide: isGuide) { [weak self] index in
            self?.pushXieYi(index: index)
        }
        scrollView.addSubview(iapPage)
        iapPage.frame = CGRect(x: view.bounds.width * (isGuide ? 3 : 0), y: 0, width: view.bounds.width, height: view.bounds.height)
        iapPage.closeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.finished()
            })
            .disposed(by: disposeBag)
        
        // 引导页
        if isGuide {
            for (i, texts) in config.texts.enumerated() {
                let page = HYZTIAPGuidePage(imageName: "\(config.imagePrefix)\(i)", imageFrame: config.imageFrames[i], bigText: texts.bigText, smallText: texts.smallText)
                scrollView.addSubview(page)
                page.frame = CGRect(x: view.bounds.width * CGFloat(i), y: 0, width: view.bounds.width, height: view.bounds.height)
            }
            
            // 隐藏购买按钮
            scrollView.rx.contentOffset
                .map({ ($0.x + 0.01) / 375~ < 3 })
                .bind(to: iapPage.productView.rx.isHidden)
                .disposed(by: disposeBag)
        }
    }
    
    func nextBtn() {
        let nextBtn = UIButton(title: "继续", textColor: config.btnTextColor, font: config.btnFont~, backgroundColor: config.btnBackgroundColor)
        if let btnImageName = config.btnImageName {
            nextBtn.setBackgroundImage(UIImage(named: btnImageName), for: .normal)
        }
        view.addSubview(nextBtn)
        nextBtn.frame = CGRect(x: (375 - config.btnWidth) / 2, y: config.btnTop, width: config.btnWidth, height: config.btnHeight)~
        nextBtn.layer.cornerRadius = config.btnCornerRadius~
        nextBtn.layer.masksToBounds = true
        // 点击继续
        nextBtn.rx.tap
            .subscribe(onNext: { [unowned self] in
                // 滚动到下一页
                let currentIndex = Int((self.scrollView.contentOffset.x + 0.01) / 375~)
                scrollView.setContentOffset(CGPoint(x: ((currentIndex + 1) * 375)~, y: 0), animated: true)
            })
            .disposed(by: disposeBag)
        
        // 隐藏继续按钮
        scrollView.rx.contentOffset
            .map({ ($0.x + 0.01) / 375~ >= 3 })
            .bind(to: nextBtn.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func subscribe() {
        HYZTIAPViewModel.success
            .subscribe(onNext: { [weak self] msg in
                if let msg = msg {
                    HUD.showSucceed(msg, on: self?.view, completed:  {
                        self?.finished()
                    })
                } else {
                    self?.finished()
                }
            })
            .disposed(by: disposeBag)
        
        HYZTIAPViewModel.failure
            .subscribe(onNext: { msg in
                guard let msg = msg else {
                    HUD.hide()
                    return
                }
                HUD.showFailed(msg)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    init(isGuide: Bool = false, finished: @escaping () -> Void) {
        self.isGuide = isGuide
        self.finished = finished
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
