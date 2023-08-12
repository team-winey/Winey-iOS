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
        img.image = .Login.logo?.resizeWithWidth(width: 196)
        return img
    }()
    
    private let title: UILabel = {
        let text = UILabel()
        text.setText("절약을 더 쉽고 재밌게", attributes: Const.titleAttributes)
        return text
    }()
    
    private let character: UIImageView = {
        let img = UIImageView()
        img.image = .Login.character?.resizeWithWidth(width: 280)
        return img
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
        addSubviews(logo, title, character)
        
        logo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(27)
            $0.leading.equalToSuperview().inset(57)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(80)
            $0.trailing.equalToSuperview().inset(50)
        }
        
        character.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(88)
            $0.horizontalEdges.equalToSuperview()
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
