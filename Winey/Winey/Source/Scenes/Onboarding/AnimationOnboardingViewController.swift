//
//  AnimationnOnboardingViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/08/17.
//

import UIKit

import DesignSystem
import Lottie
import SnapKit


class AnimationOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private var onboardingData: [AnimationOnboardingDataModel] = []
    private var currentPage: Int = 0
    
    // MARK: - UI Components
    
    private let chatImageView = UIImageView()
    private let canvasImageView = UIImageView(image: .Img.canvas)
    private var animationView = LottieAnimationView()
    private let bottomView = UIView()
    private let pageLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let skipButton = UIButton()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.arrow, for: .normal)
        button.layer.cornerRadius = 28
        button.backgroundColor = .winey_yellow
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setOnboardingData()
        setOnboardingData(data: onboardingData, page: currentPage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let logEvent = LogEventImpl(category: .view_storytelling)
        AmplitudeManager.logEvent(event: logEvent)
    }
    
    func setOnboardingData(data: [AnimationOnboardingDataModel], page: Int) {
        self.chatImageView.image = data[page].chatImage
        self.animationView.animation = data[page].animationView.animation
        self.pageLabel.setText("\(data[page].page + 1)/3", attributes: Const.pageAttributes)
        self.subtitleLabel.setText(data[page].subtitle, attributes: Const.subtitleAttributes)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .repeat(3)
        animationView.play()
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
            AnimationOnboardingDataModel(
                chatImage: .Img.chat1 ?? UIImage(),
                animationView: AnimationView.onboardingView1,
                page: 0,
                subtitle: "세이버 쫓겨나는 중..."
            ),
            AnimationOnboardingDataModel(
                chatImage: .Img.chat2 ?? UIImage(),
                animationView: AnimationView.onboardingView2,
                page: 1,
                subtitle: "세이버 상황 파악 중..."
            ),
            AnimationOnboardingDataModel(
                chatImage: .Img.chat3 ?? UIImage(),
                animationView: AnimationView.onboardingView3,
                page: 2,
                subtitle: "세이버 우는 중..."
            )
        ])
    }
    
    // MARK: - @objc
    
    @objc
    private func nextButtonTapped() {
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": "storytelling_next_button",
                "page_number": currentPage + 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        if currentPage == onboardingData.count - 1 {
            skipButton.isHidden = true
            let setNicknameVC = NicknameViewController(viewType: .onboarding)
            self.switchRootViewController(rootViewController: setNicknameVC, animated: true)
        } else {
            currentPage += 1
            setOnboardingData(data: onboardingData, page: currentPage)
        }
        print(currentPage)
    }
    
    @objc
    private func skipButtonTapped() {
        currentPage = onboardingData.count - 1
        setOnboardingData(data: onboardingData, page: currentPage)
    }
}

extension AnimationOnboardingViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .winey_gray50
        titleLabel.numberOfLines = 2
        self.titleLabel.setText( "위니제국 세이버의\n눈물나는 스토리", attributes: Const.titleAttributes)
        bottomView.layer.cornerRadius = 10
        bottomView.backgroundColor = .winey_gray0
        
        let skipAtrributeString = Typography.build(string: "건너뛰기", attributes: Const.skipButtonAttributes)
        skipButton.setAttributedTitle(skipAtrributeString, for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    private func setLayout() {
        view.addSubviews(chatImageView, canvasImageView, animationView, bottomView, nextButton)
        bottomView.addSubviews(pageLabel, titleLabel, subtitleLabel, skipButton)
        
        chatImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(56)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(56)
            make.height.equalTo(30)
        }
    }
}

extension AnimationOnboardingViewController {
    enum Const {
        static let pageAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray900
        )
        static let titleAttributes = Typography.Attributes(
            style: .headLine3,
            weight: .bold,
            textColor: .winey_gray900
        )
        static let subtitleAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray500
        )
        static let skipButtonAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}

extension AnimationOnboardingViewController {
    struct AnimationOnboardingDataModel {
        let chatImage: UIImage
        let animationView: LottieAnimationView
        let page: Int
        let subtitle: String
        
        init(chatImage: UIImage, animationView: LottieAnimationView, page: Int, subtitle: String) {
            self.chatImage = chatImage
            self.animationView = animationView
            self.page = page
            self.subtitle = subtitle
        }
    }
}
