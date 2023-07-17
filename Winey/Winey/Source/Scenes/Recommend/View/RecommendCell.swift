//
//  RecommendCell.swift
//  Winey
//
//  Created by 김인영 on 2023/07/13.
//

import UIKit

import DesignSystem
import SnapKit

final class RecommendCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeCornerRound(radius: 6)
        return imageView
    }()
    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.makeCornerRound(radius: 6)
        return imageView
    }()
    private let discountLabel = UILabel()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private let separatorLineView = UIView()
    private let linkTitleLabel = UILabel()
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.link, for: .normal)
        return button
    }()
    private let moreLinkLabel: UILabel = {
        let label = UILabel()
        label.setText("보러가기", attributes: .init(
            style: .body3,
            weight: .bold,
            textColor: .winey_gray500
            )
        )
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: RecommendFeedModel) {
        imageView.image = model.image
        discountLabel.setText(model.discount, attributes: Const.discountAttributes)
        titleLabel.setText(model.title, attributes: Const.titleAttributes)
        linkTitleLabel.setText(model.link, attributes: Const.linkTitleAttributes)
    }
}

extension RecommendCell {
    private func setUI() {
        contentView.makeCornerRound(radius: 10)
        contentView.makeShadow(radius: 3, offset: CGSize(width: 0, height: 2), opacity: 0.1)
        contentView.backgroundColor = .winey_gray0
        separatorLineView.backgroundColor = .winey_gray100
        imageView.backgroundColor = .winey_gray700
    }
    
    private func setLayout() {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 0
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        
        let firstContainerView = UIView()
        let secondContainerView = UIView()
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = 2
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        
        contentView.addSubviews(containerStackView)
        containerStackView.addArrangedSubviews(firstContainerView, separatorLineView, secondContainerView)
        firstContainerView.addSubviews(imageView, textStackView)
        textStackView.addArrangedSubviews(discountLabel, titleLabel)
        firstContainerView.addSubviews(imageView)
        secondContainerView.addSubviews(linkTitleLabel, linkButton, moreLinkLabel)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(13)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        separatorLineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Const.imageViewTopSpacing)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(Const.imageViewBottomSpacing)
            $0.size.equalTo(Const.imageViewHeight)
        }
        
        linkTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(13)
        }
        
        linkButton.snp.makeConstraints {
            $0.trailing.equalTo(moreLinkLabel.snp.leading).offset(-4)
            $0.size.equalTo(18)
            $0.centerY.equalTo(moreLinkLabel)
        }
        
        moreLinkLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}

private extension RecommendCell {
    enum Const {
        static let imageViewTopSpacing: CGFloat = 20
        static let imageViewBottomSpacing: CGFloat = 20
        static let imageViewHeight: CGFloat = 50
        static let linkTitleLabelTopSpacing: CGFloat = 17
        static let linkTitleLabelBottomSpacing: CGFloat = 13
        static let linkTitleLabelHeight: CGFloat = 17
        
        static let discountAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_purple400
        )
        static let titleAttributes = Typography.Attributes(
            style: .body,
            weight: .bold,
            textColor: .winey_gray900
        )
        static let linkTitleAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray600
        )
    }
}

extension RecommendCell {
    static func cellHeight() -> CGFloat {
        return Const.imageViewTopSpacing
        + Const.imageViewHeight
        + Const.imageViewBottomSpacing
        + Const.linkTitleLabelTopSpacing
        + Const.linkTitleLabelBottomSpacing
        + Const.linkTitleLabelHeight
    }
}
