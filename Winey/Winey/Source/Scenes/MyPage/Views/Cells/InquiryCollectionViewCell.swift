//
//  InquiryCollectionViewCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/13.
//

import UIKit

import SnapKit
import DesignSystem

protocol InquiryCollectionViewCellDelegate: AnyObject{
    func buttonDidTapped()
}

final class InquiryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = InquiryCollectionViewCell.className
    
    // MARK: - UIComponents

    var buttonImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Icon.next
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "1:1 문의",
            attributes: .init(style: .body, weight: .medium, textColor: .winey_gray700),
            customAttributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func setUI() {
        contentView.backgroundColor = .white
    }

    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, buttonImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(23)
        }
        buttonImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
}
