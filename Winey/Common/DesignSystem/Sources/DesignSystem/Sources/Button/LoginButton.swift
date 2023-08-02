//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/02.
//

import UIKit

import SnapKit

public final class LoginButton: UIButton {
    
    // MARK: - Property
    private let type: LoginButtonType
    
    // MARK: - UI Components
    
    private let btnStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 15
        stack.axis = .horizontal
        return stack
    }()
    
    private let btnLogo: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()

    private let btnLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Init func
    public init(type: LoginButtonType) {
        self.type = type
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        btnLogo.image = type.logo.resizeWithWidth(width: 24.0)
        btnLabel.setText(type.guide, attributes: type.textStyle)
        backgroundColor = type.backgroundColor
        makeCornerRound(radius: 12.0)
    }
    
    private func setLayout() {
        addSubview(btnStack)
        btnStack.addArrangedSubview(btnLogo)
        btnStack.addArrangedSubview(btnLabel)
        
        btnStack.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
