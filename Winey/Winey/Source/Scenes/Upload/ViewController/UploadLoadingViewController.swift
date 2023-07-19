//
//  UploadLoadingViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/20.
//

import UIKit

import Combine
import DesignSystem
import Lottie
import SnapKit

final class UploadLoadingViewController: UIViewController {
    private let arrowImageView = UIImageView()
    private let todayLabel = UILabel()
    private let keywordContainerView = UIView()
    private let keywordLabel = UILabel()
    private let saveLabel = UILabel()
    private let animationView = AnimationView.loadingView
    
    var keyword: String?
    
    private var didCompleteUpload: Bool = false
    private var animationStartedTime: Date?
    private var animationTimer: Timer?
    
    private var bag = Set<AnyCancellable>()
    
    init(keyword: String? = nil) {
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation()
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: .whenFeedUploaded)
            .sink { [weak self] _ in
                self?.didCompleteUpload = true
                self?.dismissIfNeeded()
            }
            .store(in: &bag)
    }
    
    private func dismissIfNeeded() {
        guard let animationStartedTime else { return }
        
        let difference = Date().timeIntervalSince(animationStartedTime)
        
        if difference > 3 {
            navigationController?.dismiss(animated: true)
        }
    }
    
    private func startAnimation() {
        let transform = CGAffineTransform.identity.translatedBy(x: 0, y: -10)
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [.repeat, .autoreverse],
            animations: { self.arrowImageView.transform = transform }
        )
        
        animationView.play()
        animationStartedTime = Date()
        animationTimer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(didTimerEnd),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func didTimerEnd() {
        if didCompleteUpload {
            navigationController?.dismiss(animated: true)
        }
    }
}

extension UploadLoadingViewController {
    private func setUI() {
        view.backgroundColor = .winey_gray0
        arrowImageView.image = .Img.loading_arrow
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        todayLabel.setText("오늘은", attributes: Const.titleAttributes)
        let keyword = (keyword ?? "") + " 값을"
        keywordLabel.setText(keyword, attributes: Const.titleAttributes)
        saveLabel.setText("절약했어요", attributes: Const.titleAttributes)
        keywordContainerView.backgroundColor = .winey_yellow
        todayLabel.textAlignment = .center
        saveLabel.textAlignment = .center
        keywordLabel.textAlignment = .center
    }
    
    private func setLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(arrowImageView)
        view.addSubview(stackView)
        view.addSubview(animationView)
        stackView.addArrangedSubview(todayLabel)
        stackView.addArrangedSubview(keywordContainerView)
        stackView.addArrangedSubview(saveLabel)
        keywordContainerView.addSubview(keywordLabel)
        
        arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(28)
            make.height.equalTo(56)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(arrowImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        animationView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(33)
            make.bottom.equalToSuperview().inset(34)
            make.leading.equalToSuperview().offset(67)
            make.trailing.equalToSuperview().inset(39)
        }
        keywordLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(1)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
}

private extension UploadLoadingViewController {
    enum Const {
        static let titleAttributes = Typography.Attributes(
            style: .headLine,
            weight: .bold,
            textColor: .winey_gray900
        )
    }
}
