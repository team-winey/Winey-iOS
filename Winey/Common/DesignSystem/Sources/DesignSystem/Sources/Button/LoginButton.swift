//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/02.
//

import UIKit

public final class LoginButton: UIButton {
    
    // MARK: - Property
    private let type: LoginButtonType
    
    // MARK: - Init func
    public init(type: LoginButtonType) {
        self.type = type
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        
        let guideText = Typography.build(string: type.guide, attributes: type.textStyle)
        setAttributedTitle(guideText, for: .normal)
        
        setImage(type.logo.resizeWithWidth(width: 24.0), for: .normal)
        
        contentEdgeInsets = .init(top: 0, left: 7.5, bottom: 0, right: 7.5)
        imageEdgeInsets = .init(top: 0, left: -7.5, bottom: 0, right: -7.5)
        titleEdgeInsets = .init(top: 0, left: 7.5, bottom: 0, right: -7.5)
        
        backgroundColor = type.backgroundColor
        makeCornerRound(radius: 12.0)
    }
}
