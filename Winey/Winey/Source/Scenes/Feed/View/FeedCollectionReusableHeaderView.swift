//
//  FeedCollectionReusableHeaderView.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

import SnapKit

final class FeedCollectionReusableHeaderView: UICollectionReusableView {
    
    private let introLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        introLabel.text = "랄랄라"
        backgroundColor = .winey_gray300
        
        addSubviews(introLabel)
        
        introLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
