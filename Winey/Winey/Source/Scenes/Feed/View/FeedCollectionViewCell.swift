//
//  FeedCollectionViewCell.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import UIKit

import SnapKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Sample.temp
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .body3_m14
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.more, for: .normal)
        return button
    }()
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Sample.temp
        imageView.makeCornerRound(radius: 5)
        return imageView
    }()
    
    private let feedMoneyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_yellow
        return view
    }()
    
    private let feedMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = .detail_m13
        label.textColor = .winey_gray900
        return label
    }()
    
    private let feedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .body_b16
        label.textColor = .winey_gray900
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .detail_m11
        label.textColor = .winey_gray700
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .winey_purple400
        button.setImage(.Icon.like_selected, for: .normal)
        button.makeCornerRound(radius: 18)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        backgroundColor = .winey_gray0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.makeCornerCircle()
        feedMoneyContainerView.makeCornerCircle()
        likeButton.makeCornerCircle()
    }
    
    func dataBind(model: FeedModel) {
        nicknameLabel.text = model.nickname
        feedMoneyLabel.text = "\(model.feedMoney)원 절약"
        feedTitleLabel.text = model.feedTitle
        likesLabel.text = "\(model.likes)"
    }
}

extension FeedCollectionViewCell {
    private func setLayout() {
        addSubviews(profileImageView, nicknameLabel, moreButton, feedImageView, feedTitleLabel, feedMoneyContainerView,  likesLabel, likeButton)
        feedMoneyContainerView.addSubview(feedMoneyLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(36)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(6)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(36)
        }
        
        feedImageView.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(182)
        }
        
        feedMoneyContainerView.snp.updateConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(12)
            $0.leading.equalTo(feedImageView)
            $0.height.equalTo(34)
            $0.width.equalTo(feedMoneyLabel.snp.width).offset(28)
        }
        
        feedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(feedMoneyContainerView.snp.bottom).offset(9)
            $0.leading.equalToSuperview().inset(26)
        }
        
        feedMoneyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(11)
            $0.trailing.equalTo(feedImageView)
            $0.size.equalTo(36)
        }
        
        likesLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(2)
            $0.centerX.equalTo(likeButton)
        }
    }
}

