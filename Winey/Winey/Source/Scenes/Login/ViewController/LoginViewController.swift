//
//  LoginViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/02.
//

import AuthenticationServices
import UIKit

import DesignSystem
import SnapKit

class LoginViewController: UIViewController {

    // MARK: - UI Components
    
    private let appleButton: LoginButton = {
        let button = LoginButton(type: .apple)
        return button
    }()
    
    private let kakaoButton: LoginButton = {
        let button = LoginButton(type: .kakao)
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        view.addSubviews(kakaoButton, appleButton)
        
        kakaoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(500)
            $0.height.equalTo(54)
        }
        
        appleButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(kakaoButton.snp.horizontalEdges)
            $0.height.equalTo(54)
        }
    }
}

