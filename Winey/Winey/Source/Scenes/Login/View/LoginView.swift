//
//  LoginView.swift
//  Winey
//
//  Created by 김응관 on 2023/08/03.
//

import UIKit

import DesignSystem
import SnapKit

final class LoginView: UIView {
    
    // MARK: - UI Components
    
    private let logo: UIImageView = {
        let img = UIImageView()
        img.image = .Login.logo?.resizeWithWidth(width: UIScreen.main.bounds.width - 194)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let title: UILabel = {
        let text = UILabel()
        text.setText("절약을 더 쉽고 재밌게", attributes: Const.titleAttributes)
        text.sizeToFit()
        text.contentMode = .scaleAspectFit
        return text
    }()
    
    // MARK: - Init func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        addSubviews(logo, title)
        
        logo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

private extension LoginView {
    enum Const {
        static let titleAttributes = Typography.Attributes(
            style: .headLine4,
            weight: .medium,
            textColor: .winey_gray600
        )
    }
}
