//
//  SetupCollectionViewCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import Combine
import UIKit

import SnapKit
import DesignSystem

final class MyfeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var myfeedButtonTappedClosure: (() -> Void)?
    static let identifier = MyfeedCollectionViewCell.className
    
    // MARK: - UIComponents
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(myfeedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    var buttonImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Icon.next
        return image
    }()
    
    let myfeedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setText(
            "마이피드",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray700
            )
        )
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    @objc
    private func myfeedButtonTapped() {
        self.myfeedButtonTappedClosure?()
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
        contentView.addSubviews(myfeedLabel, buttonImageView)
        
        myfeedLabel.snp.makeConstraints { make in
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
