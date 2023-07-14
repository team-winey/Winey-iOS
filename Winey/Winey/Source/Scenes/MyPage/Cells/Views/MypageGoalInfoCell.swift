//
//  MypageGoalInfoCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit
import SnapKit
import DesignSystem

final class MypageGoalInfoCell: UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: Component

    static let identifier = MypageGoalInfoCell.className
    
    var goalContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray200
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    var goalTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "절약 목표",
            attributes: .init(
                style: .detail,
                weight: .medium,
                textColor: .winey_gray900
                )
            )
        label.sizeToFit()
        return label
    }()
    
    var goalLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "10,000원",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.sizeToFit()
        return label
    }()
    
    lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.winey_gray200
        button.clipsToBounds = true
        button.setImage(.Mypage.pen, for: .normal)
        return button
    }()
    
    var savingPeriodTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "절약기간",
            attributes: .init(
                style: .detail,
                weight: .medium,
                textColor: .winey_gray600
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    var savingPeriodLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "D-18",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    var accumulatedWineyTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "누적위니",
            attributes: .init(
                style: .detail,
                weight: .medium,
                textColor: .winey_gray600
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    var accumulatedWineyLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "50,000원",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    var wineyCountTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "위니횟수",
            attributes: .init(
                style: .detail,
                weight: .medium,
                textColor: .winey_gray600
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    var wineyCountLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "80번",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    func setUI() {
        contentView.backgroundColor = .white
    }
    
    // MARK: Layout
    
    func setLayout() {
        contentView.addSubviews(goalContainerView, savingPeriodTitleLabel, savingPeriodLabel,
                                accumulatedWineyTitleLabel, accumulatedWineyLabel, wineyCountTitleLabel, wineyCountLabel)
        goalContainerView.addSubviews(goalTitleLabel, goalLabel, modifyButton)
        
        goalTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(22)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(22)
        }
        
        modifyButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        goalContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(18)
            make.width.equalTo(358)
            make.height.equalTo(69)
        }
        
        savingPeriodTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(47)
            make.top.equalToSuperview().inset(107)
        }
        
        savingPeriodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(48)
            make.bottom.equalToSuperview().inset(18)
        }
        
        accumulatedWineyTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(107)
        }
        
        accumulatedWineyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(18)
        }
        
        wineyCountTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(47)
            make.top.equalToSuperview().inset(107)
        }
        
        wineyCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(48)
            make.bottom.equalToSuperview().inset(18)
        }
    }
}
