//
//  Typography.swift
//  DesignSystem
//
//  Created by Woody Lee on 2023/07/13.
//

import UIKit

extension Typography {
    public static func font(style: Attributes.TypoStyle, weight: Font.Weight) -> UIFont {
        let font = Font.WineyFont(name: .Pretendard, weight: weight)
        return UIFont(name: font.fileName, size: style.fontSize)!
    }
    
    public static func build(
        string: String?,
        attributes: Attributes
    ) -> NSMutableAttributedString {
        var stringAttributes: [NSAttributedString.Key: Any] = [:]
        
        let weight = Font.Weight(rawValue: attributes.weight.rawValue)!
        let font = font(style: attributes.style, weight: weight)
        
        stringAttributes[.font] = font
        stringAttributes[.baselineOffset] = (attributes.style.lineHeight - font.lineHeight) / 4
        
        if let textColor = attributes.textColor {
            stringAttributes[.foregroundColor] = textColor
        }
        
        stringAttributes[.kern] = attributes.style.kern
        
        return NSMutableAttributedString(string: string ?? "", attributes: stringAttributes)
    }
}
