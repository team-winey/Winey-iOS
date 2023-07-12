//
//  UILabel+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit

extension UILabel {
    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedStr.length))
            self.attributedText = attributedStr
        }
    }
    
    func setLineSpacingWithChaining(lineSpacing: CGFloat) -> UILabel {
        let label = self
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style
            ]
            label.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        return label
    }
    
    /// 자간 설정 메서드
    func setCharacterSpacing(_ spacing: CGFloat) {
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))

        self.attributedText = attributedStr
    }
    
    /// 자간과 행간을 모두 조정하는 메서드
    func setLineAndCharacterSpacing(lineSpacing: CGFloat, characterSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedStr.length))
            attributedStr.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedStr.length))
            self.attributedText = attributedStr
        }
    }
    
    func setAttributedText(targetFontList: [String: UIFont], targetColorList: [String: UIColor]) {
        let fullText = self.text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        for dic in targetFontList {
            let range = (fullText as NSString).range(of: dic.key)
            attributedString.addAttribute(.font, value: dic.value, range: range)
        }
        
        for dic in targetColorList {
            let range = (fullText as NSString).range(of: dic.key)
            attributedString.addAttribute(.foregroundColor, value: dic.value, range: range)
        }
        self.attributedText = attributedString
    }
    
    func changePartColor(targetString: String, textColor: UIColor) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        self.attributedText = attributedString
    }
    
    func setupLabel(text: String, font: UIFont, color: UIColor) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.kern: -0.67, .foregroundColor: color, .font: font], range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}

struct TextAttribute {
    static let titleAttribute: [NSAttributedString.Key: Any] = {
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.head_b20,
            .foregroundColor: UIColor.black,
            .kern: -0.67
        ]
        
        return attribute
    }()
}
