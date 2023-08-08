//
//  CommentCell.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import UIKit

import DesignSystem
import SnapKit

final class CommentCell: UITableViewCell {
    private let levelLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let commentLabel = UILabel()
    
    struct ViewModel: Hashable {
        let id = UUID()
        let level: String
        let nickname: String
        let comment: String
        let isMine: Bool
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        levelLabel.setText(viewModel.level, attributes: Const.userInfoAttributes)
        nicknameLabel.setText(viewModel.nickname, attributes: Const.userInfoAttributes)
        commentLabel.setText(viewModel.comment, attributes: Const.commentAttributes)
    }
}

extension CommentCell {
    private func setupAttribute() {
        moreButton.setImage(.Btn.more, for: .normal)
    }
    
    private func setupLayout() {
        let containerView = UIView()
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(18)
        }
        
        let userInfoView = setupUserInfoView()
        containerView.addSubview(userInfoView)
        contentView.addSubview(commentLabel)
        userInfoView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    private func setupUserInfoView() -> UIView {
        let dotView = UIView()
        dotView.layer.cornerRadius = 1
        dotView.layer.masksToBounds = true

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubviews(levelLabel, dotView, nicknameLabel, moreButton)
        
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(2)
        }
        moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        return stackView
    }
}

private extension CommentCell {
    enum Const {
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
