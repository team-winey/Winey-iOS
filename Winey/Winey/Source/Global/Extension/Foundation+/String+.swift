//
//  String+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit

extension String {
    func setAttributeString(range: NSRange, font: UIFont, textColor: UIColor) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.foregroundColor, value: textColor, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        return attributeString
    }
    
    /// String을 UIImage로 반환하는 메서드
    func makeImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}
