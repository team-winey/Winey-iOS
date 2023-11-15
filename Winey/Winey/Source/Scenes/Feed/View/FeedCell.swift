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
    
    var moreButtonTappedClosure: ((Int, Int) -> Void)?
    var likeButtonTappedClosure: ((Int, Bool) -> Void)?
    var feedId: Int?
    var userId: Int?
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
    
    private let nicknameLabel = UILabel()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(.Btn.more, for: .normal)
        button.addTarget(self, action: #selector(tapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Sample.sample1
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .winey_gray200
        imageView.makeCornerRound(radius: 5)
        return imageView
    }()
    
    private let feedMoneyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_yellow
        return view
    }()
    
    private let feedMoneyLabel = UILabel()
    
    private let feedTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let likeCountLabel = UILabel()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .winey_purple100
        button.setImage(.Icon.like_unselected, for: .normal)
        button.makeCornerRound(radius: 18)
        button.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private let commentImageView = UIImageView(image: .Icon.comment)
    private let commentCountLabel = UILabel()
    private let timeAgoLabel = UILabel()
    
    private let underLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.isLiked = false
        self.feedId = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.makeCornerCircle()
        feedMoneyContainerView.makeCornerCircle()
        likeButton.makeCornerCircle()
    }
    
    func configure(model: FeedModel) {
        self.feedId = model.feedId
        self.userId = model.userId
        nicknameLabel.setText(model.nickname, attributes: Const.nicknameAttributes)
        configureFeedMoneyLabel(model.money)
        feedTitleLabel.setText(model.title, attributes: Const.feedTitleAttributes)
        feedImageView.kf.indicatorType = .activity
        let url = URL(string: model.image)
        feedImageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.1)), .fromMemoryCacheOrRefresh]
        )
        likeCountLabel.setText("\(model.like)", attributes: Const.likeCountAttributes)
        self.isLiked = model.isLiked
        profileImageView.image = model.profileImage
        commentCountLabel.setText("\(model.comments)", attributes: Const.metaInfoAttributes)
        timeAgoLabel.setText("\(model.timeAgo)", attributes: Const.metaInfoAttributes)
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
        if let feedId = self.feedId, let userId = self.userId {
            self.moreButtonTappedClosure?(feedId, userId)
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
        underLineView.backgroundColor = .winey_gray100
        likeCountLabel.textAlignment = .center
        
        let containerView = UIView()
        let dividerView = UIView()
        dividerView.backgroundColor = .winey_gray300
        
        addSubviews(profileImageView, nicknameLabel, moreButton, feedImageView, feedTitleLabel)
        addSubviews(feedMoneyContainerView, likeCountLabel, likeButton, underLineView, containerView)
        containerView.addSubviews(commentImageView, commentCountLabel, dividerView, timeAgoLabel)
        feedMoneyContainerView.addSubview(feedMoneyLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(36)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(6)
            $0.trailing.equalTo(moreButton.snp.leading).offset(-10)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(36)
        }
        
        feedImageView.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(268)
        }
        
        feedMoneyContainerView.snp.updateConstraints {
            $0.leading.equalTo(feedImageView).offset(12)
            $0.bottom.equalTo(feedImageView.snp.bottom).inset(12)
            $0.height.equalTo(34)
            $0.width.equalTo(feedMoneyLabel.snp.width).offset(28)
        }
        
        feedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalTo(likeButton.snp.leading).offset(-4)
        }
        
        feedMoneyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(feedTitleLabel)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentImageView.snp.trailing).offset(4)
            make.centerY.equalTo(commentImageView).offset(-2)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.equalTo(commentCountLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(13)
        }
        timeAgoLabel.snp.makeConstraints { make in
            make.leading.equalTo(dividerView.snp.trailing).offset(8)
            make.centerY.equalTo(commentImageView).offset(-2)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(feedTitleLabel)
            $0.trailing.equalToSuperview().inset(26)
            $0.size.equalTo(36)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(4)
            $0.centerX.equalTo(likeButton)
        }
        
        underLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
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
            textColor: .winey_gray700
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
        static let metaInfoAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}
