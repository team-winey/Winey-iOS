//
//  LoginView.swift
//  Winey
//
//  Created by 김응관 on 2023/08/03.
//

import UIKit

import DesignSystem
import SnapKit

final class LoginView {
    
    // MARK: - UI Components
    
    private let logo: UIImageView = {
        let img = UIImageView()
        img.image = .Login.logo?.resizeWithWidth(width: 196)
        return img
    }()
    
    private let title: UILabel = {
        let text = UILabel()
        text.textColor = .winey_gray600
        text.setText("절약을 더 쉽고 재밌게", attributes: .headLine4)
        return text
    }()
    
    private let character: UIImageView = {
        let img = UIImageView()
        img.image = .Login.character?.resizeWithWidth(width: 196)
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
        addSubViews(logo, title, character)
        
        logo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        character.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(88)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview()
        }
    }
}
