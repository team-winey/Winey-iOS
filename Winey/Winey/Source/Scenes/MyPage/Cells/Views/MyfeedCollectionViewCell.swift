//
//  SetupCollectionViewCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit
import SnapKit
import DesignSystem

final class MyfeedCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: Component
    
    static let identifier = "MyfeedCollectionViewCell"
    
    let enterButton: UIButton = {
        let button = UIButton()
        // TODO: 이미지 삽입
        button.setImage(UIImage(named: "ic_next"), for: .normal)
        button.backgroundColor = .white
        return button
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
    
    private func setStyle() {
        contentView.backgroundColor = .white
    }
    
    // MARK: Layout
    
    private func setLayout() {
        
        contentView.addSubviews(myfeedLabel, enterButton)
        
        myfeedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(23)
            make.trailing.equalToSuperview().inset(312)
        }
        enterButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.height.equalTo(55)
        }
    }
}