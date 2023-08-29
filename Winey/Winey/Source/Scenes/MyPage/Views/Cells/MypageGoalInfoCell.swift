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
        let duringGoalAmount : Int?
        let duringGoalCount : Int?
        let targetMoney : Int?
        let dday: Int?
        
        init(_ duringGoalAmount: Int?, _ duringGoalCount: Int?, _ targetMoney: Int?, _ dday: Int?) {
            self.duringGoalCount = duringGoalCount
            self.duringGoalAmount = duringGoalAmount
            self.targetMoney = targetMoney
            self.dday = dday
        }
    }
    
    // MARK: - Properties

    var saveGoalButtonTappedClosure : (() -> Void)?
    var blockAlertTappedClosure: (() -> Void)?
    
    private var dday: String = ""
    private var goalAmount: String = "0"
    private var target: String = "0"
    
    // MARK: - UIComponents
    
    private var goalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray0
        return view
    }()
    
    private var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray0
        return view
    }()
    
    private var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .winey_gray0
        return view
    }()
    
    private let firstDevideLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.winey_gray200
        label.text = "|"
        label.font = UIFont.systemFont(ofSize: 27)
        return label
    }()
    
    private let firstDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_gray200
        return view
    }()
    
    private let secondDevideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.winey_gray200
        return view
    }()

    
    private var goalContainerViewButton: UIButton = {
        let containerView = UIButton()
        containerView.backgroundColor = UIColor.winey_gray50
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.winey_gray200.cgColor
        containerView.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        return containerView
    }()
    
    private var goalTitleLabel: UILabel = {
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
    
    private var goalLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "아직 없어요",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.sizeToFit()
        return label
    }()
    
    private lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.clipsToBounds = true
        button.setImage(.Icon.pen, for: .normal)
        button.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var savingPeriodTitleLabel: UILabel = {
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
    
    private var savingPeriodLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "아직 없어요",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    private var accumulatedWineyTitleLabel: UILabel = {
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
    
    private var accumulatedWineyLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "0원",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    private var wineyCountTitleLabel: UILabel = {
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
    
    private var wineyCountLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "0번",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
                )
            )
        label.textAlignment = .center
        return label
    }()
    
    private var devideView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray50
        return containerView
    }()
    
    @objc
    private func modifyButtonTapped() {
        ["아직 없어요", "D-0"].contains(dday) || goalAmount >= target ? self.saveGoalButtonTappedClosure?() : self.blockAlertTappedClosure?()
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
        goalAmount = model.duringGoalAmount?.addCommaToString() ?? "0"
        
        accumulatedWineyLabel.setText(
            "\(goalAmount)원",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
            )
        )
        let goalCount = model.duringGoalCount ?? 0
        wineyCountLabel.setText(
            "\(goalCount)번",
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
            )
        )
        
        if let targetMoney = model.targetMoney {
            target = targetMoney.addCommaToString() ?? "0"
            goalLabel.setText(
                "\(target)원",
                attributes: .init(
                    style: .headLine4,
                    weight: .bold,
                    textColor: .winey_gray900
                )
            )
        } else {
            goalLabel.setText(
                "아직 없어요",
                attributes: .init(
                    style: .headLine4,
                    weight: .bold,
                    textColor: .winey_gray900
                )
            )
        }
        
        dday = model.dday == nil ? "아직 없어요" : "D-\(model.dday ?? 0)"
        
        savingPeriodLabel.setText(
            dday,
            attributes: .init(
                style: .headLine4,
                weight: .bold,
                textColor: .winey_gray900
            )
        )
        
        savingPeriodLabel.textAlignment = .center
        wineyCountLabel.textAlignment = .center
        accumulatedWineyLabel.textAlignment = .center
    }
    
    // MARK: - Layout
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    private func setLayout() {
        contentView.addSubviews(goalContainerViewButton, goalInfoStackView)
        contentView.addSubviews(firstDevideView, secondDevideView, devideView)
        
        goalContainerViewButton.addSubviews(goalTitleLabel, goalLabel, modifyButton)
        goalInfoStackView.addArrangedSubviews(leftView, centerView, rightView)
        leftView.addSubviews(savingPeriodLabel, savingPeriodTitleLabel)
        centerView.addSubviews(accumulatedWineyTitleLabel, accumulatedWineyLabel)
        rightView.addSubviews(wineyCountTitleLabel, wineyCountLabel)
        
        devideView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(centerView.snp.bottom)
        }
        
        leftView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        rightView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        goalContainerViewButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(18)
                        
            goalTitleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(13)
                make.leading.equalToSuperview().inset(22)
            }
            
            goalLabel.snp.makeConstraints { make in
                make.top.equalTo(goalTitleLabel.snp.bottom).offset(2)
                make.leading.equalToSuperview().inset(22)
                make.bottom.equalToSuperview().inset(12)
            }
            
            modifyButton.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
                make.trailing.equalToSuperview()
                make.width.equalTo(modifyButton.snp.height)
            }
        }
        
        goalInfoStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
            
            savingPeriodTitleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(14)
                make.horizontalEdges.equalToSuperview()
                make.centerX.equalToSuperview().inset(32)
            }
            
            savingPeriodLabel.snp.makeConstraints { make in
                make.top.equalTo(savingPeriodTitleLabel.snp.bottom).offset(6)
                make.horizontalEdges.equalToSuperview()
                make.centerX.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(13)
            }
            
            firstDevideView.snp.makeConstraints { make in
                make.leading.equalTo(leftView.snp.trailing)
                make.centerY.equalTo(leftView)
                make.width.equalTo(1)
                make.height.equalTo(22)
            }
            
            secondDevideView.snp.makeConstraints { make in
                make.leading.equalTo(centerView.snp.trailing)
                make.centerY.equalTo(centerView)
                make.width.equalTo(1)
                make.height.equalTo(22)
            }
            
            accumulatedWineyTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(32)
                make.horizontalEdges.equalToSuperview()
                make.top.equalToSuperview().inset(14)
            }
            
            accumulatedWineyLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(4)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(13)
            }
            
            wineyCountTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(32)
                make.top.equalToSuperview().inset(14)
                make.horizontalEdges.equalToSuperview()
            }
            
            wineyCountLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(13)
                make.horizontalEdges.equalToSuperview()
            }
        }
    }
}
