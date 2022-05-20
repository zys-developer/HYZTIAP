
import UIKit
import SwiftyFitsize
import YSExtensions
import SnapKit

class HYZTIAPGuidePage: UIView {
    
    let config = HYZTIAPConfig.shared.delegate!
    
    init(imageName: String, imageFrame: CGRect, bigText: String, smallText: String) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        let imageView = UIImageView(imageName)
        addSubview(imageView)
        imageView.frame = imageFrame~
        
        let bigLabel = UILabel(text: bigText, font: config.bigTextFont~, textColor: config.bigTextColor, textAlignment: .center, backgroundColor: nil)
        addSubview(bigLabel)
        bigLabel.snp.makeConstraints { make in
            make.top.equalTo(config.textTop~)
            make.centerX.equalToSuperview()
        }
        
        let smallLabel = UILabel(text: smallText, font: config.smallTextFont~, textColor: config.smallTextColor, textAlignment: .center, backgroundColor: nil)
        addSubview(smallLabel)
        smallLabel.snp.makeConstraints { make in
            make.top.equalTo(bigLabel.snp.bottom).offset(config.textSpacing)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
