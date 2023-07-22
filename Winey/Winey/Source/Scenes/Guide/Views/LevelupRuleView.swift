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
        view.backgroundColor = UIColor.winey_darkYellow
        return view
    }()
    
    let secondDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_darkYellow
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
        backgroundColor = .winey_lightYellow
        addSubviews(levelupRuleTitleLabel, levelupRuleLabel,
                                                  levelupRuleGuideImageView, knightTypeLabel,
                                                  nobleTypeLabel, emperorTypeLabel,
                                                  knightTypeExplainLabel, nobleTypeExplainLabel,
                                                  emperorTypeExplainLabel)
        addSubviews(firstDevideView, secondDevideView)
                
        levelupRuleTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(23)
            make.trailing.equalToSuperview().inset(90)
        }
        
        levelupRuleLabel.snp.makeConstraints { make in
            make.top.equalTo(levelupRuleTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(23)
            make.trailing.equalToSuperview().inset(56)
        }
        
        levelupRuleGuideImageView.snp.makeConstraints { make in
            make.top.equalTo(levelupRuleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(207)
        }
        
        knightTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(levelupRuleGuideImageView.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(135)
        }
        
        knightTypeExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(levelupRuleGuideImageView.snp.bottom).offset(25)
            make.leading.equalTo(knightTypeLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(135)
        }
        
        firstDevideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(knightTypeExplainLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        nobleTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.top.equalTo(firstDevideView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(89)
        }
        
        nobleTypeExplainLabel.snp.makeConstraints { make in
            make.leading.equalTo(nobleTypeLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(89)
            make.top.equalTo(firstDevideView.snp.bottom).offset(12)
        }
        
        secondDevideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(nobleTypeExplainLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        emperorTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(secondDevideView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(43)
        }
        
        emperorTypeExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDevideView.snp.bottom).offset(12)
            make.leading.equalTo(emperorTypeLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(43)
            make.trailing.equalToSuperview().inset(17)
        }
    }
}
