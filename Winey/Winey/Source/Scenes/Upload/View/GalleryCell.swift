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
    
    var label: UILabel = {
        let label = UILabel()
        label.setText("접근 권한이 허용된 사진",
                      attributes: .init(style: .body3,
                                        weight: .medium))
        label.sizeToFit()
        return label
    }()
    
    private let arrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "chevron.right")
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
        contentView.backgroundColor = .red
    }
    
    private func setLayout() {
        contentView.addSubview(arrow)
        
        arrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
}
