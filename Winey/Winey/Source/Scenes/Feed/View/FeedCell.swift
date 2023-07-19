//
//  FeedCollectionViewCell.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import UIKit

import DesignSystem
import SnapKit
import Kingfisher

final class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var moreButtonTappedClosure: ((Int) -> Void)?
    var likeButtonTappedClosure: ((Int, Bool) -> Void)?
    var feedId: Int?
    var isLiked: Bool = false {
        didSet {
            self.changeLikeButtonLayout()
        }
    }
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Sample.sample1
        return imageView
    }()
    
    private let nicknameLabel: UILabel = UILabel()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.more, for: .normal)
        button.addTarget(self, action: #selector(tapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Sample.sample1
        imageView.makeCornerRound(radius: 5)
        return imageView
    }()
    
    private let feedMoneyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_yellow
        return view
    }()
    
    private let feedMoneyLabel: UILabel = UILabel()
    
    private let feedTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let likeCountLabel: UILabel = UILabel()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .winey_purple100
        button.setImage(.Icon.like_unselected, for: .normal)
        button.makeCornerRound(radius: 18)
        button.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        feedImageView.image = nil
        nicknameLabel.text = "초기 닉네임"
        feedTitleLabel.text = "초기 titleLabel"
        likeCountLabel.text = "0"
        self.isLiked = false
        self.feedId = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.makeCornerCircle()
        feedMoneyContainerView.makeCornerCircle()
        likeButton.makeCornerCircle()
    }
    
    func configure(model: FeedModel) {
        self.feedId = model.id
        nicknameLabel.setText(model.nickname, attributes: Const.nicknameAttributes)
        configureFeedMoneyLabel(model.money)
        feedTitleLabel.setText(model.title, attributes: Const.feedTitleAttributes)
        let url = URL(string: model.image)
        feedImageView.kf.setImage(with: url)
        likeCountLabel.setText("\(model.like)", attributes: Const.likeCountAttributes)
        self.isLiked = model.isLiked
    }
    
    private func configureFeedMoneyLabel(_ money: Int) {
        let money = money.addCommaToString() ?? ""
        let feedMoneyText = Typography.build(
            string: money + "원 ",
            attributes: Const.feedMoneyAttributes
        )
        feedMoneyLabel.attributedText = feedMoneyText.appending(
            string: "절약",
            attributes: Const.feedMoneyDescriptionAttributes
        )
    }
    
    @objc private func tapMoreButton() {
        if let feedId = self.feedId {
            self.moreButtonTappedClosure?(feedId)
        }
    }
    
    @objc private func tapLikeButton() {
        if let feedId = self.feedId {
            isLiked.toggle()
            self.likeButtonTappedClosure?(feedId, isLiked)
        }
    }
}

extension FeedCell {
    
    private func setLayout() {
        
        backgroundColor = .winey_gray0
        
        addSubviews(profileImageView, nicknameLabel, moreButton, feedImageView, feedTitleLabel)
        addSubviews(feedMoneyContainerView, likeCountLabel, likeButton)
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
            $0.trailing.equalTo(likeButton.snp.leading).offset(-13)
        }
        
        feedMoneyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(11)
            $0.trailing.equalTo(feedImageView)
            $0.size.equalTo(36)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(2)
            $0.centerX.equalTo(likeButton)
        }
    }

    private func changeLikeButtonLayout() {
        if self.isLiked {
            likeButton.backgroundColor = .winey_purple400
            likeButton.setImage(.Icon.like_selected, for: .normal)
        } else {
            likeButton.backgroundColor = .winey_purple100
            likeButton.setImage(.Icon.like_unselected, for: .normal)
        }
    }
}

// MARK: - Const

private extension FeedCell {
    enum Const {
        static let nicknameAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray900
        )
        static let feedMoneyAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray900
        )
        static let feedMoneyDescriptionAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray600
        )
        static let feedTitleAttributes = Typography.Attributes(
            style: .body,
            weight: .bold,
            textColor: .winey_gray900
        )
        static let likeCountAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray700
        )
    }
}
