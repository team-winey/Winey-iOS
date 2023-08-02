//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/02.
//

import UIKit

public struct LoginButtonType {
    public let logo: UIImage
    public let textStyle: Typography.Attributes
    public let backgroundColor: UIColor
    public let guide: String

    public init(
        logo: UIImage,
        textStyle: Typography.Attributes,
        backgroundColor: UIColor,
        guide: String
    ) {
        self.logo = logo
        self.textStyle = textStyle
        self.backgroundColor = backgroundColor
        self.guide = guide
    }
}

public extension LoginButtonType {
    
    static let kakao: LoginButtonType = LoginButtonType(
        logo: .Icon.kakao ?? UIImage(),
        textStyle: .init(style: .body, weight: .medium, textColor: .winey_gray900),
        backgroundColor: .winey_kakaoYellow,
        guide: Const.kakao.text
    )
    static let apple: LoginButtonType = LoginButtonType(
        logo: .Icon.apple ?? UIImage(),
        textStyle: .init(style: .body, weight: .medium, textColor: .winey_gray0),
        backgroundColor: .winey_gray900,
        guide: Const.apple.text
    )
}

public extension LoginButtonType {
    enum Const {
        case kakao
        case apple
        
        var text: String {
            switch self {
            case .kakao: return "카카오톡으로 3초만에 시작하기"
            case .apple: return "Apple로 계속하기"
            }
        }
    }
}
