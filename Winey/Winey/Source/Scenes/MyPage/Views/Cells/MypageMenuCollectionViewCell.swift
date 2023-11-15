//
//  MypageMenuCollectionViewCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/30.
//

import Combine
import UIKit

import SnapKit
import DesignSystem

final class MypageMenuCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    enum MenuType {
        case myfeed
        case inquiry
    }
    
    static let identifier = MypageMenuCollectionViewCell.className
    weak var delegate: MypageMenuCollectionViewCellDelegate?
    
    // MARK: - UIComponents
    
    var buttonImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Icon.next
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setText(
            "타이틀라벨",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray700
            )
        )
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func setUI() {
        contentViw.backgroundColor = .white
    }
    
    @objc private func myfeedButtonTapped() {
        delegate?.buttonDidTapped()
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
    
    internal func bindHeader(type: HomeCellType,
                             rowCount: Int = 0) {
        DispatchQueue.main.async {
            self.addSubview(titleLabel, buttonImageView)
            
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
        switch type {
        case .myfeed:
            self.titleLabel.text = "마이피드"
            
        case .inquiry:
            self.titleLabel.setText(
                "1:1 문의",
                attributes: .init(
                    style: .body,
                    weight: medium,
                    textColor: .winey_gray700
                ),customAttributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
            )
        }
    }
}
