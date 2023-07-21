//
//  LevelupDescriptionView.swift
//  Winey
//
//  Created by 고영민 on 2023/07/15.
//

import UIKit

import SnapKit
import DesignSystem

final class LevelupDescriptionView: UIView {
    
    // MARK: - UI Components
    
    private let guide_character: UIImageView = {
         let image = UIImageView()
         image.image = .Img.guide_character
         image.sizeToFit()
         return image
     }()
     
     private let guide_character_hand: UIImageView = {
         let image = UIImageView()
         image.image = .Img.guide_character_hand
         image.sizeToFit()
         return image
     }()
     
    
    private let levelupContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_purple100
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    private let levelupDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "레벨업을 어떻게 하나요?",
            attributes: .init(
            style: .headLine3,
            weight: .bold,
            textColor: .winey_gray900
            )
        )
        return label
    }()
    
    private let levelupDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setText(
            "목표금액과 기간을 설정하고,\n목표를 달성하면 레벨업을 할 수 있어요!",
            attributes: .init(
            style: .body,
            weight: .medium,
            textColor: .winey_gray600
            )
        )
        return label
    }()
    
    private let levelupDescriptionGuideImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Mypage.guide1
        image.sizeToFit()
        return image
    }()
    
    // MARK: - View Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: - UI & Layout
    
    func setLayout() {
        levelupContainerView.addSubviews(levelupDescriptionTitleLabel, levelupDescriptionLabel,
                                                    levelupDescriptionGuideImageView, guide_character_hand)
        self.addSubview(guide_character)
        self.addSubview(levelupContainerView)
        
        levelupContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(365)
        }
        
        guide_character.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(264)
            make.centerY.equalTo(levelupContainerView.snp.top)
        }
        
        guide_character_hand.snp.makeConstraints { make in
            make.verticalEdges.equalTo(guide_character)
            make.horizontalEdges.equalTo(guide_character)
        }
        
        levelupDescriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23)
            make.leading.equalToSuperview().inset(23)
        }
        
        levelupDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(51)
            make.leading.equalToSuperview().inset(23)
        }
        
        levelupDescriptionGuideImageView.snp.makeConstraints { make in
            make.top.equalTo(levelupContainerView).inset(125)
            make.leading.equalTo(levelupContainerView).inset(50)
        }
    }
}
