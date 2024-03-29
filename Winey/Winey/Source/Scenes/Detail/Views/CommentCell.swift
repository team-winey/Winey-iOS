//
//  CommentCell.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import Combine
import UIKit

import DesignSystem
import SnapKit

final class CommentCell: UITableViewCell {
    private let levelLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let commentLabel = UILabel()
    private let dividerView = UIView()
    
    private var didTapMoreButtonSubject = PassthroughSubject<Void, Never>()
    var didTapMoreButtonPublisher: AnyPublisher<Void, Never> {
        didTapMoreButtonSubject.eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()
    
    struct ViewModel: Hashable {
        let id: Int
        let level: String
        let nickname: String
        let comment: String
        let isMine: Bool
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
    
    func configure(viewModel: ViewModel) {
        levelLabel.setText("LV. " + viewModel.level, attributes: Const.userInfoAttributes)
        nicknameLabel.setText(viewModel.nickname, attributes: Const.userInfoAttributes)
        commentLabel.setText(viewModel.comment, attributes: Const.commentAttributes)
    }
    
    @objc private func didTapMoreButton() {
        didTapMoreButtonSubject.send(())
    }
    
    func subscribeTapMoreButton(_ handler: @escaping () -> Void) {
        didTapMoreButtonPublisher
            .sink(receiveValue: handler)
            .store(in: &bag)
    }
}

extension CommentCell {
    private func setupAttribute() {
        commentLabel.numberOfLines = 0
        moreButton.setImage(.Btn.more, for: .normal)
        moreButton.tintColor = .winey_gray300
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        dividerView.backgroundColor = .winey_gray100
    }
    
    private func setupLayout() {
        let userInfoView = setupUserInfoView()
        let containerView = UIView()
        
        contentView.addSubview(containerView)
        contentView.addSubview(dividerView)
        containerView.addSubview(userInfoView)
        containerView.addSubview(commentLabel)
        containerView.addSubview(moreButton)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Const.containerViewTopSpacing)
            make.leading.equalToSuperview().offset(Const.containerViewLeading)
            make.trailing.equalToSuperview().inset(Const.containerViewTrailing)
            make.bottom.equalToSuperview().inset(Const.containerViewBottomSpacing)
        }
        dividerView.snp.makeConstraints { make in
            make.bottom.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalTo(moreButton.snp.leading)
            make.height.equalTo(Const.userInfoViewHeight)
        }
        moreButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(36)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom)
            make.bottom.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    private func setupUserInfoView() -> UIView {
        let stackView = UIStackView()
        let dotView = UIView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        dotView.layer.cornerRadius = 1
        dotView.layer.masksToBounds = true
        dotView.backgroundColor = .winey_gray600
        
        stackView.addArrangedSubviews(levelLabel, dotView, nicknameLabel)
        
        levelLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(2)
        }
        return stackView
    }
}

private extension CommentCell {
    enum Const {
        static let containerViewTopSpacing: CGFloat = 8
        static let containerViewLeading: CGFloat = 26
        static let containerViewTrailing: CGFloat = 10
        static let containerViewBottomSpacing: CGFloat = 18
        static let userInfoViewHeight: CGFloat = 36
        static let userInfoAttributes = Typography.Attributes(
            style: .detail2,
            weight: .medium,
            textColor: .winey_gray600
        )
        static let commentAttributes = Typography.Attributes(
            style: .body2,
            weight: .medium,
            textColor: .winey_gray900
        )
    }
}
