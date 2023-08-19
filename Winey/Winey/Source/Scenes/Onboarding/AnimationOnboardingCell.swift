//
//  AnimationOnboardingCell.swift
//  Winey
//
//  Created by 김인영 on 2023/08/17.
//

import UIKit

import DesignSystem
import Lottie
import SnapKit

class AnimationOnboardingCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let chatImageView = UIImageView()
    private let canvasImageView = UIImageView(image: .Img.canvas)
    private var animationView = LottieAnimationView()
    private let bottomView = UIView()
    private let pageLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOnboardingData(model: AnimationOnboardingDataModel) {
        self.chatImageView.image = model.chatImage
        self.animationView.animation = model.animationView.animation
        self.pageLabel.setText("\(model.page)/3", attributes: Const.pageAttributes)
        self.subtitleLabel.setText(model.subtitle, attributes: Const.subtitleAttributes)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .repeat(3)
        animationView.play()
    }
    
    private func setUI() {
        titleLabel.numberOfLines = 2
        self.titleLabel.setText( "위니제국 세이버의\n눈물나는 스토리", attributes: Const.titleAttributes)
        bottomView.layer.cornerRadius = 10
        bottomView.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        contentView.addSubviews(chatImageView, canvasImageView, animationView)
        contentView.addSubviews(bottomView)
        bottomView.addSubviews(pageLabel, titleLabel, subtitleLabel)
        
        chatImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(228)
        }
        
        canvasImageView.snp.makeConstraints { make in
            make.top.equalTo(chatImageView.snp.bottom).offset(-31)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(390)
        }
        
        animationView.snp.makeConstraints{ make in
            make.edges.equalTo(canvasImageView)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(canvasImageView.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(22)
            make.leading.equalTo(pageLabel)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
        }
    }
}

extension AnimationOnboardingCell {
    enum Const {
        static let pageAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray400
        )
        static let titleAttributes = Typography.Attributes(
            style: .headLine3,
            weight: .bold,
            textColor: .winey_gray900
        )
        static let subtitleAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray600
        )
    }
}

struct AnimationOnboardingDataModel {
    var chatImage: UIImage
    var animationView: LottieAnimationView
    var page: Int
    var subtitle: String
    
    init(chatImage: UIImage, animationView: LottieAnimationView, page: Int, subtitle: String) {
        self.chatImage = chatImage
        self.animationView = animationView
        self.page = page
        self.subtitle = subtitle
    }
}
