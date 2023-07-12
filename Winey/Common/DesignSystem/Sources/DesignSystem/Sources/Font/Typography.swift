//
//  Attributes.swift
//  DesignSystem
//
//  Created by Woody Lee on 2023/07/13.
//

import UIKit

public enum Typography {
    public struct Attributes {
        public var style: TypoStyle
        public var weight: Weight
        public var textColor: UIColor?
        
        public init(style: TypoStyle, weight: Weight, textColor: UIColor? = nil) {
            self.style = style
            self.weight = weight
            self.textColor = textColor
        }
    }
}

extension Typography.Attributes {
    public enum Weight: String {
        case bold
        case medium
        
        public var rawValue: String {
            switch self {
            case .bold: return "Bold"
            case .medium: return "Medium"
            }
        }
    }
    
    public struct TypoStyle {
        let fontSize: CGFloat
        let lineHeight: CGFloat
        let kern: CGFloat
        
        public init(fontSize: CGFloat, lineHeight: CGFloat, kern: CGFloat = -0.3) {
            self.fontSize = fontSize
            self.lineHeight = lineHeight
            self.kern = kern
        }
    }
}


public extension Typography.Attributes.TypoStyle {
    static let headLine = Self.init(
        fontSize: 28,
        lineHeight: 30,
        kern: -0.7
    )
    
    static let headLine2 = Self.init(
        fontSize: 24,
        lineHeight: 28,
        kern: -0.6
    )
    
    static let headLine3 = Self.init(
        fontSize: 20,
        lineHeight: 24,
        kern: -0.5
    )
    
    static let headLine4 = Self.init(
        fontSize: 18,
        lineHeight: 24,
        kern: -0.4
    )
    
    static let body = Self.init(
        fontSize: 16,
        lineHeight: 22
    )
    
    static let body2 = Self.init(
        fontSize: 15,
        lineHeight: 22
    )
    
    static let body3 = Self.init(
        fontSize: 14,
        lineHeight: 20
    )
    
    static let detail = Self.init(
        fontSize: 13,
        lineHeight: 18
    )
    
    static let detail2 = Self.init(
        fontSize: 12,
        lineHeight: 17
    )
    
    static let detail3 = Self.init(
        fontSize: 11,
        lineHeight: 15
    )
    
    static let detail4 = Self.init(
        fontSize: 10,
        lineHeight: 14
    )
}
