
import UIKit
import SwiftyFitsize
import YSExtensions
import SnapKit

public class HYZTIAPGuidePage: UIView {
    
    public let bigLabel: UILabel
    public let smallLabel: UILabel
    public let imageView: UIImageView
    
    init(imageName: String, imageFrame: CGRect, bigText: String, smallText: String) {
        let config = HYZTIAPConfig.shared.delegate!
        bigLabel = UILabel(text: bigText, font: config.bigTextFont~, textColor: config.bigTextColor, textAlignment: .center, backgroundColor: nil)
        smallLabel = UILabel(text: smallText, font: config.smallTextFont~, textColor: config.smallTextColor, textAlignment: .center, backgroundColor: nil)
        imageView = UIImageView(imageName)
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.frame = imageFrame~
        
        bigLabel.numberOfLines = 0
        addSubview(bigLabel)
        bigLabel.snp.makeConstraints { make in
            make.top.equalTo(config.textTop~)
            make.leading.trailing.equalToSuperview()
        }
        
        smallLabel.numberOfLines = 0
        addSubview(smallLabel)
        smallLabel.snp.makeConstraints { make in
            make.top.equalTo(bigLabel.snp.bottom).offset(config.textSpacing~)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
