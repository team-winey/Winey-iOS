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
    
    struct ViewModel {
        let duringGoalAmount : Int
        let duringGoalCount : Int
        let targetMoney : Int
        let dday: Int
    }
    
    // MARK: - Properties

    static let identifier = MypageGoalInfoCell.className
    
    // MARK: - UIComponents
    
    var goalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray0
        return view
    }()
    
    var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray0
        return view
    }()
    
    var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray0
        return view
    }()
    
    let firstDevideLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.winey_gray200
        label.text = "|"
        label.font = UIFont.systemFont(ofSize: 27)
        return label
    }()
    
    let firstDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_gray200
        view.frame = CGRect(x: 0, y: 0, width: 2, height: 10)
        return view
    }()
    
    let secondDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_gray200
        view.frame = CGRect(x: 0, y: 0, width: 2, height: 10)
        return view
    }()

    
    var goalContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray50
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
        button.backgroundColor = UIColor.clear
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
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    func configure(model: ViewModel) {
        accumulatedWineyLabel.setText(
            "\(model.duringGoalAmount)원",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        wineyCountLabel.setText(
            "\(model.duringGoalCount)번",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        goalLabel.setText(
            "\(model.targetMoney)원",
                attributes: .init(
                    style: .headLine4,
                    weight: .bold,
                    textColor: .winey_gray900
                    )
                )
        savingPeriodLabel.setText(
            "D-\(model.dday)",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
    }
    
    // MARK: - Layout
    
    func setLayout() {
        contentView.addSubviews(goalContainerView, goalInfoStackView)
        
        goalContainerView.addSubviews(goalTitleLabel, goalLabel, modifyButton)

        
        goalInfoStackView.addSubviews(leftView,centerView,rightView, firstDevideView, secondDevideView)
        
        leftView.addSubviews(savingPeriodLabel, savingPeriodTitleLabel)
        
        centerView.addSubviews(accumulatedWineyTitleLabel, accumulatedWineyLabel)
        
        rightView.addSubviews(wineyCountTitleLabel, wineyCountLabel)
        
        leftView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(74)
        }
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(74)
        }
        rightView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(74)
        }
        
        goalContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(18)
            make.width.equalTo(358)
            make.height.equalTo(69)
                        
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
                make.width.height.equalTo(69)
            }
        }
        
        goalInfoStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(6)
            make.width.equalTo(360)
            make.height.equalTo(74)
            
            savingPeriodTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(32)
                make.top.equalToSuperview().inset(14)
            }
            
            savingPeriodLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(13)
            }
            
            firstDevideView.snp.makeConstraints { make in
                make.trailing.equalTo(leftView)
                make.verticalEdges.equalToSuperview().inset(14)
                make.width.equalTo(1)
                make.height.equalTo(22)
            }
            
            secondDevideView.snp.makeConstraints { make in
                make.trailing.equalTo(centerView)
                make.verticalEdges.equalToSuperview().inset(14)
                make.width.equalTo(1)
                make.height.equalTo(22)
            }
            
            accumulatedWineyTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(32)
                make.top.equalToSuperview().inset(14)
            }
            
            accumulatedWineyLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(13)
            }
            
            wineyCountTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(32)
                make.top.equalToSuperview().inset(14)
            }
            
            wineyCountLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(13)
            }
        }
    }
}
