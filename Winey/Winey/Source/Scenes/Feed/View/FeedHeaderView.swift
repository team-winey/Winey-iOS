//
//  FeedHeaderView.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

import SnapKit

final class FeedHeaderView: UICollectionReusableView {
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setupLabel(text: "이웃나라 왕족들의 소비생활을\n관찰하고 소통할 수 있어요!", font: .head_b20, color: .winey_gray900)
//        label.text = "이웃나라 왕족들의 소비생활을\n관찰하고 소통할 수 있어요!"
//        label.font = .head_b20
//        label.textColor = .winey_gray900
        label.attributedText = NSAttributedString(string: "text", attributes: TextAttribute.titleAttribute)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray100
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "아니, 어제만해도 왕족인 내가 평민이라고?\n용납할 수 없지. 얘들아 모여봐 뭔일이야"
        label.font = .body3_m14
        label.textColor = .winey_gray600
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Sample.temp
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        
        backgroundColor = .winey_gray0
        
        self.addSubviews(introLabel, containerView, characterImageView)
        containerView.addSubview(subtitleLabel)
        
        introLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(28)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(introLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(77) /// top bottom
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(17)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.trailing.equalTo(containerView)
            $0.width.equalTo(112)
            $0.height.equalTo(140)
        }
    }
}
