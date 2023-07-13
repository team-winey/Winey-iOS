//
//  RecommendCell.swift
//  Winey
//
//  Created by 김인영 on 2023/07/13.
//

import UIKit

import DesignSystem
import SnapKit

class RecommendCell: UICollectionViewCell {
    
    private let testView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .winey_gray300
        testView.backgroundColor = .winey_purple300
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecommendCell {
    private func setLayout() {
        contentView.addSubviews(testView)
        
        testView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
