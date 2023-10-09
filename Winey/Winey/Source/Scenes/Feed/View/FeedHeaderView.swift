//
//  FeedHeaderView.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

import Combine
import DesignSystem
import SnapKit

enum BannerState: CaseIterable {
    case initial
    case refreshed
    
    public var banner: FeedHeaderView.BannerType {
        switch self {
        case .initial:
            return .banner5
        case .refreshed:
            return .allCases.randomElement() ?? .banner5
        }
    }
}

final class FeedHeaderView: UICollectionReusableView {
    
    private let containerView = UIView()
    private let introLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    
    private let didTapSubject = PassthroughSubject<URL?, Never>()
    var didTapPublisher: AnyPublisher<URL?, Never> {
        didTapSubject.eraseToAnyPublisher()
    }

    private var state: BannerType = .banner1

    var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(_ state: BannerState) {
        setBannerUI(state.banner)
    }
    
    private func setLayout(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
        self.addGestureRecognizer(tapGesture)
      
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
    
    func setBannerUI(_ state: BannerType) {
        imageView.image = state.image
        containerView.backgroundColor = state.backgroundColor

        switch state {
        case .banner1:
            introLabel.setText(state.introTitle, attributes: Const.titleAttributes)
            subtitleLabel.setText(state.subtitle, attributes: Const.subtitleAttributes)
        case .banner2, .banner3, .banner4:
            introLabel.setText(state.introTitle, attributes: Const.subtitleAttributes)
            subtitleLabel.setText(state.subtitle, attributes: Const.titleAttributes)
        case .banner5:
            introLabel.setText(state.introTitle, attributes: Const.whiteTitleAttributes)
            subtitleLabel.setText(state.subtitle, attributes: Const.whiteSubtitleAttributes)
        }
        setBannerLayout(state)
    }

    @objc private func didTapGesture() {
        didTapSubject.send(state.url)
    }

    private func setBannerLayout(_ state: BannerType) {
        switch state {
        case .banner1:
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(11)
                make.trailing.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview().inset(8)
                make.width.equalTo(94)
            }
        case .banner2:
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(12)
                make.width.equalTo(129)
            }
        case .banner3:
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(18)
                make.width.equalTo(142)
            }
        case .banner4:
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(35)
                make.trailing.equalToSuperview().inset(34)
                make.bottom.equalToSuperview().inset(30)
                make.width.equalTo(115)
            }
        case .banner5:
            imageView.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.bottom.equalToSuperview()
                make.width.equalTo(132)
            }
        }
    }
}

extension FeedHeaderView {
    public enum BannerType: CaseIterable {
        case banner1
        case banner2
        case banner3
        case banner4
        case banner5

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
            case .banner5:
                return "무슨 앱인지 궁금하다면?"
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
            case .banner5:
                return "위니 공식 인스타에서\n더 재밌게 사용하는 법 알아보기!"
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
            case .banner5:
                return .Img.banner5
            }
        }

        var backgroundColor: UIColor? {
            switch self {
            case .banner5:
                return .winey_gray700
            default:
                return .winey_gray100
            }
        }

        var url: URL? {
            // TODO: 배너마다 분기처리가 필요합니다. - 재용
            // 아래 URL은 Winey 공식 인스타그램입니다.
            return URL(string: "https://instagram.com/winey__official?igshid=MzRlODBiNWFlZA==")
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
        static let whiteTitleAttributes = Typography.Attributes(
            style: .headLine3,
            weight: .bold,
            textColor: .winey_gray0
        )
        static let whiteSubtitleAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray200
        )
    }
}
