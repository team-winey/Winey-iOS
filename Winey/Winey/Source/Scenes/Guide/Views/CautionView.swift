//
//  CautionView.swift
//  Winey
//
//  Created by 고영민 on 2023/07/15.
//

import UIKit

import SnapKit
import DesignSystem

final class CautionView: UIView {
    
    // MARK: - UI Components
    
    var closeButtonTappedClosure: (() -> Void)?
    private let cautionTitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "주의사항",
            attributes: .init(
            style: .body3,
            weight: .bold,
            textColor: .winey_gray900
            )
        )
        return label
    }()
    
    private let cautionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.setText(
            "귀족 레벨부터는 레벨을 유지하기 위해 주 3회이상 출석을 해야해요!\n절약 인증 사진을 삭제하면 목표 기간 내에 누적된 절약 금액이 삭감\n되며 경우에 따라 레벨이 강등될 수 있어요.\n삭제는 신중하게 해주세요.",
            attributes: .init(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray400
            )
        )
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.winey_gray500, for: .normal)
        button.backgroundColor = .winey_gray200
        button.layer.cornerRadius = 10
        button.addTarget(self,
                         action: #selector(closeButtonTapped),
                         for: .touchUpInside
        )
        return button
    }()
    
    @objc
    private func closeButtonTapped() {
        self.closeButtonTappedClosure?()
    }
    
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
        self.addSubviews(cautionTitleLabel, cautionLabel, closeButton)
        
        cautionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(17)
        }
        
        cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(cautionTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview().inset(17)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(358)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().inset(4)
            make.centerX.equalToSuperview().inset(16)
        }
    }
}
