//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/16.
//

import UIKit

public final class DuplicateCheckButton: UIButton {
    
    // MARK: - Init func
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 56)
    }
    
    private func setUI() {
        let btnText = Typography.build(string: "중복확인", attributes: Typography.Attributes(style: .body3,
                                                                           weight: .medium,
                                                                           textColor: .winey_gray700))
        setAttributedTitle(btnText, for: .normal)
        backgroundColor = .winey_gray50
        makeCornerRound(radius: 5)
    }
}
