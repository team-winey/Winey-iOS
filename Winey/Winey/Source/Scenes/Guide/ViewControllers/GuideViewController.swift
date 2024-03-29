//
//  GuideViewController.swift
//  Winey
//
//  Created by 고영민 on 2023/07/15.
//

import UIKit
import DesignSystem
import SnapKit

final class GuideViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var navigationBar: WINavigationBar = {
        let naviBar = WINavigationBar(leftBarItem: .back)
        naviBar.title = "더 즐거운 위니 사용법"
        return naviBar
    }()
    private lazy var safearea = self.view.safeAreaLayoutGuide
    private let scrollView = UIScrollView()
    private let bubbleView = BubbleView()
    private let levelupDescriptionView = LevelupDescriptionView()
    private let levelupRuleView = LevelupRuleView()
    private let cautionView = CautionView()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
        setupCloseButtonClosure()
    }
    
    private func setupCloseButtonClosure() {
        cautionView.closeButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setAddTarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapRightButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GuideViewController {
    
    // MARK: - Layout
    
    private func setUI() {
        levelupRuleView.makeCornerRound(radius: 12)
        navigationBar.hideBottomSeperatorView = false
        navigationBar.rightButton.addTarget(
            self,
            action: #selector(didTapRightButton),
            for: .touchUpInside
        )
        scrollView.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        view.backgroundColor = .winey_gray0
        view.addSubviews(navigationBar)
        view.addSubviews(scrollView)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        scrollView.addSubviews(bubbleView, levelupDescriptionView, levelupRuleView, cautionView)
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        
        levelupDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(bubbleView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(374)
        }
        
        levelupRuleView.snp.makeConstraints { make in
            make.top.equalTo(levelupDescriptionView.snp.bottom).offset(9)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        cautionView.snp.makeConstraints { make in
            make.top.equalTo(levelupRuleView.snp.bottom).offset(69)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaInsets.bottom).inset(4)
        }
    }
}
