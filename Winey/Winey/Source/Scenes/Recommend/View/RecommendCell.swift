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
    private let titleLabel = UILabel()
    private let separatorLineView = UIView()
    private let linkTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.makeCornerRound(radius: 10)
        contentView.backgroundColor = .winey_blue500
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: RecommendModel) {
        imageView.image = model.image
        discountLabel.setText(model.discount, attributes: Const.discountAttributes)
        print(model.title)
        titleLabel.setText(model.title, attributes: Const.titleAttributes)
        titleLabel.numberOfLines = 2
    }
}

extension RecommendCell {
    private func setLayout() {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 0
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        
        contentView.addSubviews(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let firstContainerView = UIView()
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = 2
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        
        containerStackView.addArrangedSubview(firstContainerView)
        firstContainerView.addSubviews(imageView, textStackView)
        textStackView.addArrangedSubviews(discountLabel, titleLabel)
        
        textStackView.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(13)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        let secondContainerView = UIView()
        containerStackView.addArrangedSubviews(separatorLineView, secondContainerView)
        
        firstContainerView.backgroundColor = .winey_red500
        secondContainerView.backgroundColor = .winey_gray700
        separatorLineView.backgroundColor = .winey_yellow
        imageView.backgroundColor = .winey_gray700
        
        firstContainerView.addSubviews(imageView)
        secondContainerView.addSubviews(linkTitleLabel)
        
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
