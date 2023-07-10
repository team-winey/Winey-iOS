//
//  FeedCollectionViewCell.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import UIKit

import SnapKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    private var nicknameLabel = UILabel()
    private var feedTitleLabel = UILabel()
    private var feedImage = UIImage()
    private var feedMoneyLabel = UILabel()
    private var likesLabel = UILabel()
    private var likeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataBind(model: FeedModel) {
        feedTitleLabel.text = model.feedTitle
    }
}

extension FeedCollectionViewCell {
    private func setLayout() {
        addSubviews(feedTitleLabel)
        
        backgroundColor = .white
        feedTitleLabel.textColor = .winey_gray900
        
        feedTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

