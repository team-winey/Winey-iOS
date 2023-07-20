//
//  RecommendHeaderView.swift
//  Winey
//
//  Created by 김인영 on 2023/07/13.
//

import UIKit

import DesignSystem
import SnapKit

final class RecommendHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "위니가 알려주는 추천 절약법",
            attributes: .init(
                style: .headLine3,
                weight: .bold,
                textColor: .winey_gray900
            )
        )
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_purple100
        view.makeCornerRound(radius: 5)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setText(
            "쉿, 그대를 위한 절약방법이 도착했어.\n황실 내에서도 비밀인데 특별히 알려줄게:)",
            attributes: .init(
                style: .body3,
                weight: .medium,
                textColor: .winey_gray900
            )
        )
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Img.recommend_character
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        addSubviews(titleLabel, containerView, characterImageView)
        containerView.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(17)
        }
        
        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(containerView)
            $0.trailing.equalTo(containerView)
            $0.width.equalTo(88)
        }
    }
}

