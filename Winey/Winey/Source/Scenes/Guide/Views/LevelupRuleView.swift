//
//  LevelupRuleView.swift
//  Winey
//
//  Created by 고영민 on 2023/07/15.
//

import UIKit

import SnapKit
import DesignSystem

final class LevelupRuleView: UIView {
    
    // MARK: - UI Components
    
    private let levelUpContainerVIew: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_lightYellow
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    private let levelupRuleTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "레벨업 규칙이 어떻게 되나요?",
            attributes: .init(
            style: .headLine3,
            weight: .bold,
            textColor: .winey_gray900
            )
        )
        return label
        
    }()
    private let levelupRuleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "목표 달성 성공여부에 따라 레벨이 달라집니다.",
            attributes: .init(
            style: .body,
            weight: .medium,
            textColor: .winey_gray600
            )
        )
        return label
    }()

    private let knightTypeLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "기사",
            attributes: .init(
                style: .body,
                weight: .bold,
                textColor: .winey_gray700
            )
        )
        return label
    }()

    private let nobleTypeLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "귀족",
            attributes: .init(
                style: .body,
                weight: .bold,
                textColor: .winey_gray700
            )
        )
        return label
    }()

    private let emperorTypeLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "황제",
            attributes: .init(
                style: .body,
                weight: .bold,
                textColor: .winey_gray700
            )
        )
        return label
    }()
    
    private let knightTypeExplainLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "목표를 총 1번 세우고 1번 달성 시 레벨업",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray600
            )
        )
        return label
    }()
    
    private let nobleTypeExplainLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "목표를 총 3번 이상 세우고 3번 달성 시 레벨업",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray600
            )
        )
        return label
    }()
    
    private let emperorTypeExplainLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "목표를 총 9번 이상 세우고 9번 달성 시 레벨업",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray600
            )
        )
        return label
    }()

    private let levelupRuleGuideImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Mypage.guide2
        image.sizeToFit()
        return image
    }()
    
    let firstDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_gray900
        view.frame = CGRect(x: 0, y: 0, width: 319, height: 3)
        return view
    }()
    
    let secondDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_gray900
        view.frame = CGRect(x: 0, y: 0, width: 319, height: 3)
        return view
    }()
    
    // MARK: - View Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: - UI & Layout
    
    func setLayout() {
        levelUpContainerVIew.addSubviews(levelupRuleTitleLabel, levelupRuleLabel,
                                                  levelupRuleGuideImageView, knightTypeLabel,
                                                  nobleTypeLabel, emperorTypeLabel,
                                                  knightTypeExplainLabel, nobleTypeExplainLabel,
                                                  emperorTypeExplainLabel)
        levelUpContainerVIew.addSubviews(firstDevideView, secondDevideView)
        
        self.addSubview(levelUpContainerVIew)
        
        firstDevideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(levelupRuleGuideImageView.snp.bottom).inset(59)
        }
        
        secondDevideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(emperorTypeExplainLabel.snp.top).offset(105)
        }
        
        levelupRuleTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(23)
        }
        
        levelupRuleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.equalToSuperview().inset(23)
        }
        
        levelupRuleGuideImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(96)
            make.leading.equalToSuperview().inset(49)
        }
        
        knightTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(135)
        }
        
        nobleTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(89)
        }
        
        emperorTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(43)
        }
        
        knightTypeExplainLabel.snp.makeConstraints { make in
            make.leading.equalTo(knightTypeLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(135)
        }
        
        nobleTypeExplainLabel.snp.makeConstraints { make in
            make.leading.equalTo(nobleTypeLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(89)
        }
        
        emperorTypeExplainLabel.snp.makeConstraints { make in
            make.leading.equalTo(emperorTypeLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(43)
        }
        
        levelUpContainerVIew.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.width.equalTo(358)
            make.height.equalTo(485)
        }
    }
}
