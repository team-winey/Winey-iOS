//
//  DetailInfoCell.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import Combine
import UIKit

import DesignSystem
import SnapKit
import Kingfisher

final class DetailInfoCell: UITableViewCell {
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let detailImageView = UIImageView()
    private let moneyLabel = UILabel()
    private let titleLabel = UILabel()
    private let likeButton = UIButton()
    private let commentImageView = UIImageView()
    private let commentCountLabel = UILabel()
    private let timeAgoLabel = UILabel()
    private let likeCountLabel = UILabel()
    private let dividerView = UIView()
    
    private var imageHeightConstraint: Constraint?
    
    private let didTapLikeButtonSubject = PassthroughSubject<Bool, Never>()
    var didTapLikeButtonPublisher: AnyPublisher<Bool, Never> {
        didTapLikeButtonSubject.eraseToAnyPublisher()
    }
    
    private let didTapMoreButtonSubject = PassthroughSubject<Void, Never>()
    var didTapMoreButtonPublisher: AnyPublisher<Void, Never> {
        didTapMoreButtonSubject.eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()
    
    struct ViewModel: Hashable {
        let userLevel: UserLevel
        let nickname: String
        var isLiked: Bool
        let title: String
        var likeCount: Int
        var commentCount: Int
        let timeAgo: String
        var imageInfo: ImageInfo
        let money: Int
        let isMine: Bool
        
        struct ImageInfo: Hashable {
            var image: UIImage?
            var imageUrl: URL
            var height: CGFloat = 300
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag.removeAll()
    }
    
    @objc private func didTapLikeButton() {
        let newDirection = likeButton.isSelected == false
        didTapLikeButtonSubject.send(newDirection)
    }
    
    @objc private func didTapMoreButton() {
        didTapMoreButtonSubject.send(())
    }
    
    func configure(viewModel: ViewModel) {
        titleLabel.setText(viewModel.title, attributes: Const.titleAttributes)
        profileImageView.image = viewModel.userLevel.profileImage
        nicknameLabel.setText(viewModel.nickname, attributes: Const.nicknameAttributes)
        moneyLabel.setText(viewModel.money.addCommaToString(), attributes: Const.moneyAttributes)
        likeButton.isSelected = viewModel.isLiked
        likeCountLabel.setText("\(viewModel.likeCount)", attributes: Const.likeCountAttributes)
        commentCountLabel.setText("\(viewModel.commentCount)", attributes: Const.metaInfoAttributes)
        timeAgoLabel.setText(viewModel.timeAgo, attributes: Const.metaInfoAttributes)
        detailImageView.image = viewModel.imageInfo.image
        imageHeightConstraint?.update(offset: viewModel.imageInfo.height)
    }
    
    func subscribeTapLikeButton(_ handler: @escaping (Bool) -> Void) {
        didTapLikeButtonPublisher
            .sink(receiveValue: handler)
            .store(in: &bag)
    }
    
    func subscribeTapMoreButton(_ handler: @escaping () -> Void) {
        didTapMoreButtonPublisher
            .sink(receiveValue: handler)
            .store(in: &bag)
    }
}

extension DetailInfoCell {
    private func setupAttribute() {
        titleLabel.numberOfLines = 2
        likeButton.setImage(.Icon.like_selected, for: .selected)
        likeButton.setImage(.Icon.like_selected, for: .highlighted)
        likeButton.setImage(.Icon.like_unselected, for: .normal)
        likeButton.setBackgroundColor(.winey_purple100, for: .normal)
        likeButton.setBackgroundColor(.winey_purple400, for: .highlighted)
        likeButton.setBackgroundColor(.winey_purple400, for: .selected)
        likeButton.makeCornerRound(radius: Const.buttonCornerRadius)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        profileImageView.makeBorder(width: 1, color: .winey_gray100)
        profileImageView.makeCornerRound(radius: Const.profileImageCornerRadius)
        detailImageView.makeBorder(width: 1, color: .winey_gray100)
        detailImageView.makeCornerRound(radius: Const.detailImageViewCornerRadius)
        detailImageView.contentMode = .scaleAspectFit
        moreButton.setImage(.Btn.more, for: .normal)
        moreButton.tintColor = .winey_gray300
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        commentImageView.image = .Icon.comment
        dividerView.backgroundColor = .winey_gray100
    }
    
    private func setupLayout() {
        let userInfoView = setupUserInfoView()
        let detailImageView = setupDetailImageView()
        let detailMetaInfoView = setupDetailMetaInfoView()
        
        contentView.addSubview(userInfoView)
        contentView.addSubview(detailImageView)
        contentView.addSubview(detailMetaInfoView)
        contentView.addSubview(dividerView)
        
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Const.userInfoViewTopSpacing)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        detailImageView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(Const.detailImageViewTopSpacing)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            self.imageHeightConstraint = make.height.equalTo(0).constraint
        }
        detailMetaInfoView.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(76)
        }
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(detailMetaInfoView.snp.bottom).offset(18)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(14)
        }
    }
    
    private func setupUserInfoView() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubviews(profileImageView, nicknameLabel, moreButton)
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(Const.profileImageSize)
        }
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(Const.buttonSize)
        }
        return stackView
    }
    
    private func setupDetailImageView() -> UIView {
        let containerView = UIView()
        let trashLabel = UILabel()
        let stackView = UIStackView()
        containerView.backgroundColor = .winey_yellow
        trashLabel.setText("절약", attributes: Const.trashAttributes)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        
        containerView.addSubviews(stackView)
        stackView.addArrangedSubviews(moneyLabel, trashLabel)
        detailImageView.addSubview(containerView)
       
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(1)
            make.directionalHorizontalEdges.equalToSuperview().inset(14)
        }
        containerView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.height.equalTo(36)
        }
        containerView.makeCornerRound(radius: 18)
        return detailImageView
    }
    
    private func setupDetailMetaInfoView() -> UIView {
        let containerView = UIView()
        let metaContainerView = UIView()
        let dividerView = UIView()
    
        dividerView.backgroundColor = .winey_gray300
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(likeButton)
        containerView.addSubview(likeCountLabel)
        containerView.addSubview(metaContainerView)
        metaContainerView.addSubview(commentImageView)
        metaContainerView.addSubview(commentCountLabel)
        metaContainerView.addSubview(dividerView)
        metaContainerView.addSubview(timeAgoLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        metaContainerView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
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
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(Const.buttonSize)
        }
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(4)
            make.centerX.equalTo(likeButton)
        }
        
        return containerView
    }
}

extension DetailInfoCell {
    enum PublicConst {
        static let inset: CGFloat = 16
    }
    private enum Const {
        static let profileImageSize: CGSize = .init(width: 36, height: 36)
        static let buttonSize: CGSize = .init(width: 36, height: 36)
        static let detailImageViewTopSpacing: CGFloat = 12
        static let userInfoViewTopSpacing: CGFloat = 12
        static let profileImageCornerRadius: CGFloat = 18
        static let detailImageViewCornerRadius: CGFloat = 5
        static let buttonCornerRadius: CGFloat = 18
        static let trashAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray600
        )
        static let nicknameAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray700
        )
        static let moneyAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray900
        )
        static let titleAttributes = Typography.Attributes(
            style: .body,
            weight: .bold,
            textColor: .winey_gray900
        )
        static let metaInfoAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray500
        )
        static let likeCountAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray700
        )
    }
}

private extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
