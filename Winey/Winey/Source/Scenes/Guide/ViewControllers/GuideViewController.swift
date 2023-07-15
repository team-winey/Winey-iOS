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
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let bubbleView = BubbleView()
    private let levelupMethodView = LevelupMethodView()
    private let levelupRuleView = LevelupRuleView()
    private let cautionView = CautionView()
    
    // MARK: - UI & Layout
    
    private func setUI() {
        scrollView.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubviews(bubbleView, levelupMethodView, levelupRuleView, cautionView)
        
        bubbleView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.top.leading.trailing.equalToSuperview()
        }
        
        levelupMethodView.snp.makeConstraints { make in
            make.height.equalTo(374)
            make.top.equalTo(bubbleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        levelupRuleView.snp.makeConstraints { make in
            make.height.equalTo(554)
            make.top.equalTo(levelupMethodView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        cautionView.snp.makeConstraints { make in
            make.height.equalTo(206)
            make.top.equalTo(levelupRuleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
