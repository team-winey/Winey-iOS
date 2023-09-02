//
//  MenuCell.swift
//  Winey
//
//  Created by 고영민 on 2023/08/09.
//

import UIKit

import SnapKit
import DesignSystem

final class MenuCell: UICollectionViewCell {

    // MARK: - UIComponents

    private var nextImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Icon.next
        return image
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var devideView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray50
        return containerView
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
        contentView.addSubviews(titleLabel, nextImageView, devideView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(23)
        }
        nextImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        devideView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(nextImageView.snp.bottom).offset(-5)
        }
    }
    // MARK: - Config
    func configureCell(_ menu: Menu) {
        titleLabel.setText(
            menu.title,
            attributes: .init(style: .body, weight: .medium, textColor: .winey_gray700)
        )
    }
}
