//
//  UIButton+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit

extension UIButton {
    
    // 글자 아래 밑줄 메서드
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
