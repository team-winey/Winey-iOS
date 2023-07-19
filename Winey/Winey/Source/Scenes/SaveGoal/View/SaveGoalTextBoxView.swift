//
//  SaveGoalView.swift
//  Winey
//
//  Created by 김인영 on 2023/07/16.
//

import UIKit

import DesignSystem
import SnapKit

enum GoalType {
    case money
    case period
    
    var title: String {
        switch self {
        case .money: return "목표 절약 금액을 설정해주세요"
        case .period: return "목표 절약 일수를 설정해주세요"
        }
    }
    
    var detail: String {
        switch self {
        case .money: return "절약 금액을 3만원 이상으로 설정해주세요"
        case .period: return "절약 일수를 5일 이상으로 설정해주세요"
        }
    }
}

final class SaveGoalTextBoxView: UIView {
    
    private let titleLabel = UILabel()
    let textField = WITextFieldView(label: .won)
    private let detailLabel = UILabel()
    
    init(frame: CGRect, type: GoalType) {
        super.init(frame: frame)
        setUI(type: type)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(type: GoalType) {
        titleLabel.setText(type.title, attributes: Const.titleAttributes)
        detailLabel.setText(type.detail, attributes: Const.detailAttributes)
        
    }
}

extension SaveGoalTextBoxView {
    private func setLayout() {
        addSubviews(titleLabel, textField, detailLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        detailLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
    }
}

private extension SaveGoalTextBoxView {
    enum Const {
        static let titleAttributes = Typography.Attributes(style: .headLine3, weight: .bold)
        static let detailAttributes = Typography.Attributes(style: .detail, weight: .medium, textColor: .winey_gray400)
    }
}
