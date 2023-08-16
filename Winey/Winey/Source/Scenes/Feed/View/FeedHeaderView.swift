//
//  FeedHeaderView.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

import DesignSystem
import SnapKit

final class FeedHeaderView: UICollectionReusableView {
    
    private let containerView = UIView()
    private let introLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(_ state: HeaderState? = nil) {
        setBannerUI(state ?? getRandomBanner())
    }
    
    private func setLayout(){
        backgroundColor = .winey_gray0
        containerView.backgroundColor = .winey_gray100
        containerView.makeCornerRound(radius: 5)
        subtitleLabel.numberOfLines = 2
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        
        let labelContainerView = UIView()
        containerView.addSubview(labelContainerView)
        labelContainerView.addSubview(introLabel)
        labelContainerView.addSubview(subtitleLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        labelContainerView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setBannerUI(_ state: HeaderState) {
        switch state {
        case .banner1:
            imageView.image = state.image
            introLabel.setText(state.introTitle, attributes: Const.titleAttributes)
            subtitleLabel.setText(state.subtitle, attributes: Const.subtitleAttributes)
            setBannerLayout(state)
        case .banner2, .banner3, .banner4:
            imageView.image = state.image
            introLabel.setText(state.introTitle, attributes: Const.subtitleAttributes)
            subtitleLabel.setText(state.subtitle, attributes: Const.titleAttributes)
            setBannerLayout(state)
        }
    }
    
    private func setBannerLayout(_ state: HeaderState) {
        switch state {
        case .banner1:
            imageView.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(11)
                make.trailing.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview().inset(8)
                make.width.equalTo(94)
            }
        case .banner2:
            imageView.snp.updateConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(12)
                make.width.equalTo(129)
            }
        case .banner3:
            imageView.snp.updateConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(18)
                make.width.equalTo(142)
            }
        case .banner4:
            imageView.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview().inset(22)
                make.trailing.equalToSuperview().inset(29)
                make.width.equalTo(111)
            }
        }
    }
    
    private func getRandomBanner() -> HeaderState {
        return HeaderState.allCases.randomElement() ?? .banner1
    }
}

extension FeedHeaderView {
    
    public enum HeaderState: CaseIterable {
        case banner1
        case banner2
        case banner3
        case banner4
        
        var introTitle: String {
            switch self {
            case .banner1:
                return "위니와 절약을 더 쉽고 재밌게!"
            case .banner2:
                return "하단 버튼을 통해"
            case .banner3:
                return "서로의 절약방법을 피드백해요"
            case .banner4:
                return "찾기 힘든 국가기관 금융혜택도"
            }
        }
        
        var subtitle: String {
            switch self {
            case .banner1:
                return "절약한 소비를 피드에 올리고\n사람들과 소통해요"
            case .banner2:
                return "나만의 절약방법을 사람들과\n공유할 수 있어요"
            case .banner3:
                return "좋아요를 눌러 서로의 절약을\n응원해주세요!"
            case .banner4:
                return "위니 추천피드에서\n한번에 볼 수 있어요!"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .banner1:
                return .Img.feed_character
            case .banner2:
                return .Img.banner2
            case .banner3:
                return .Img.banner3
            case .banner4:
                return .Img.banner4
            }
        }
    }
}

private extension FeedHeaderView {
    
    enum Const {
        static let titleAttributes = Typography.Attributes(
            style: .headLine3,
            weight: .bold
        )
        static let subtitleAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}
