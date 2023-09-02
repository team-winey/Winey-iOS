//
//  GalleryCell.swift
//  Winey
//
//  Created by 김응관 on 2023/08/31.
//

import UIKit

import DesignSystem
import SnapKit

class GalleryCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.setText("접근 권한이 허용된 사진",
                      attributes: .init(style: .body3,
                                        weight: .medium))
        label.sizeToFit()
        return label
    }()
    
    private let imageCount: UILabel = {
        let label = UILabel()
        label.setText("0",
                      attributes: .init(style: .body3, weight: .medium))
        label.sizeToFit()
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }()
    
    private let thumbnailImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "photo")?.resizeWithWidth(width: 40)?.withTintColor(.winey_gray400)
        return img
    }()
    
    private let thumbnailContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray200
        return view
    }()
    
    private let arrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.Mypage.next
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        stackView.addArrangedSubviews(label, imageCount)
        thumbnailContentView.addSubview(thumbnailImg)
        contentView.addSubviews(thumbnailContentView, stackView, arrow)
        
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        imageCount.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
        
        thumbnailImg.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        thumbnailContentView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.height.width.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImg.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        arrow.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }
}
