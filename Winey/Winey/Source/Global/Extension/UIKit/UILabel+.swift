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
    
    /// 특정 문자열에 밑줄을 추가하는 메서드
    func setUnderLine(targetString: String) {
        if let attributedText = self.attributedText?.mutableCopy() as? NSMutableAttributedString {
            let fullText = attributedText.string
            let range = (fullText as NSString).range(of: targetString)
            
            if range.location != NSNotFound {
                attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                self.attributedText = attributedText
            }
        }
    }
    
    /// 라벨 내의 특정 문자열의 CGRect 을 반환
    /// - Parameter subText: CGRect 을 알고 싶은 특정 문자열.
    func rectFromString(with subText: String) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        guard let labelText = self.text else { return nil }
        
        // 전체 텍스트(labelText)에서 subText만큼의 range를 구합니다.
        guard let subRange = labelText.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: labelText)
        
        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가합니다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // instrinsicContentSize를 기반으로 NSTextContainer를 선언하고
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 줍니다.
        textContainer.lineFragmentPadding = 0.0
        // layoutManager에 추가합니다.
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구합니다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )
        
        // textContainer 내의 지정된 glyphRange에 대한 CGRect 값을 반환합니다.
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}
