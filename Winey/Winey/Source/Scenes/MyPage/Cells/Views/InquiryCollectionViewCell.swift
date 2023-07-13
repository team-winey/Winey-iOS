//
//  InquiryCollectionViewCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/13.
//

import UIKit
import SnapKit

final class InquiryCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    static let identifier = "InquiryCollectionViewCell"
    
    // MARK: Component
    
    let enterButton: UIButton = {
        let button = UIButton()
        // TODO: 이미지 삽입
        button.setImage(UIImage(named: "ic_next_i"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let inquiryLabel: UILabel = {
        let label = UILabel()
        label.text = "1:1 문의"
        label.textAlignment = .center
        label.textColor = UIColor.winey_gray700
        label.font = .bodymain_m16
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func setStyle() {
        contentView.backgroundColor = .white
    }
    
    
    // MARK: Layout
    
    private func setLayout() {
        
        contentView.addSubviews(inquiryLabel, enterButton)
        
        inquiryLabel.snp.makeConstraints { make in
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
