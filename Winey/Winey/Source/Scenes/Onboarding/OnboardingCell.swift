//
//  OnboardingCollectionViewCell.swift
//  Winey
//
//  Created by 김인영 on 2023/08/04.
//

import UIKit

import DesignSystem
import SnapKit

class OnboardingCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOnboardingData(model: OnboardingDataModel) {
        self.titleLabel.setText(model.title, attributes: Const.titleAttributes)
        self.subtitleLabel.setText(model.subtitle, attributes: Const.subtitleAttributes)
        self.imageView.image = model.image
    }
}

extension OnboardingCell {
    
    private func setUI() {
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, subtitleLabel, imageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension OnboardingCell {
    enum Const {
        static let titleAttributes = Typography.Attributes(
            style: .headLine2,
            weight: .bold,
            textColor: .winey_gray800
        )
        static let subtitleAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray600
        )
    }
}

struct OnboardingDataModel {
    var title: String
    var subtitle: String
    var image: UIImage
    
    init(title: String, subtitle: String, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
