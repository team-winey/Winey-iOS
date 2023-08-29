//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/17.
//

import UIKit

public struct WITextFieldType {
    public var textLength: Int
    public let textLeftPadding: CGFloat
    public let textRightPadding: CGFloat
    public let labelRightPadding: CGFloat
    public let textStyle: UIFont
    public let label: String
    public let labelStyle: Typography.Attributes
    public let keyboardType: UIKeyboardType
    public let textAlignment: NSTextAlignment
    public let placeholder: String
    public let labelWidth: CGFloat
    public let labelColor: UIColor
    public let activeTextColor: UIColor
    public let activeBorderColor: UIColor
    public let inactiveTextColor: UIColor
    
    public init(
        textLeftPadding: CGFloat,
        textRightPadding: CGFloat,
        labelRightPadding: CGFloat,
        textStyle: UIFont,
        textLength: Int,
        label: String,
        labelStyle: Typography.Attributes,
        keyboardType: UIKeyboardType,
        textAlignment: NSTextAlignment,
        placeholder: String,
        labelWidth: CGFloat,
        labelColor: UIColor,
        activeTextColor: UIColor,
        activeBorderColor: UIColor,
        inactiveTextColor: UIColor
    ) {
        self.textLeftPadding = textLeftPadding
        self.textRightPadding = textRightPadding
        self.labelRightPadding = labelRightPadding
        self.textStyle = textStyle
        self.textLength = textLength
        self.label = label
        self.labelStyle = labelStyle
        self.keyboardType = keyboardType
        self.textAlignment = textAlignment
        self.placeholder = placeholder
        self.labelWidth = labelWidth
        self.labelColor = labelColor
        self.activeTextColor = activeTextColor
        self.activeBorderColor = activeBorderColor
        self.inactiveTextColor = inactiveTextColor
    }
}

public extension WITextFieldType {
    static let upload_price: WITextFieldType = WITextFieldType(
        textLeftPadding: TextField.price.textLeftPadding,
        textRightPadding: TextField.price.textRightPadding,
        labelRightPadding: TextField.price.labelRightPadding,
        textStyle: Typography.font(style: .headLine2,
                                         weight: .Bold),
        textLength: TextField.price.textLength,
        label: TextField.price.label,
        labelStyle: Typography.Attributes(style: .headLine4, weight: .bold),
        keyboardType: TextField.price.keyboardType,
        textAlignment: TextField.price.textAlignment,
        placeholder: TextField.price.placeholder,
        labelWidth: TextField.price.labelWidth,
        labelColor: TextField.price.labelColor,
        activeTextColor: TextField.price.activeTextColor,
        activeBorderColor: TextField.price.activeBorderColor,
        inactiveTextColor: TextField.price.inactiveTextColor
    )
    
    static let day: WITextFieldType = WITextFieldType(
        textLeftPadding: TextField.day.textLeftPadding,
        textRightPadding: TextField.day.textRightPadding,
        labelRightPadding: TextField.day.labelRightPadding,
        textStyle: Typography.font(style: .headLine2, weight: .Bold),
        textLength: TextField.day.textLength,
        label: TextField.day.label,
        labelStyle: Typography.Attributes(style: .headLine4, weight: .bold),
        keyboardType: TextField.day.keyboardType,
        textAlignment: TextField.day.textAlignment,
        placeholder: TextField.day.placeholder,
        labelWidth: TextField.day.labelWidth,
        labelColor: TextField.day.labelColor,
        activeTextColor: TextField.day.activeTextColor,
        activeBorderColor: TextField.day.activeBorderColor,
        inactiveTextColor: TextField.day.inactiveTextColor
    )
    
    static let nickName: WITextFieldType = WITextFieldType(
        textLeftPadding: TextField.nickName.textLeftPadding,
        textRightPadding: TextField.nickName.textRightPadding,
        labelRightPadding: TextField.nickName.labelRightPadding,
        textStyle: Typography.font(style: .headLine4,
                                         weight: .Medium),
        textLength: TextField.nickName.textLength,
        label: TextField.nickName.label,
        labelStyle: Typography.Attributes(style: .body3, weight: .medium),
        keyboardType: TextField.nickName.keyboardType,
        textAlignment: TextField.nickName.textAlignment,
        placeholder: TextField.nickName.placeholder,
        labelWidth: TextField.nickName.labelWidth,
        labelColor: TextField.nickName.labelColor,
        activeTextColor: TextField.nickName.activeTextColor,
        activeBorderColor: TextField.nickName.activeBorderColor,
        inactiveTextColor: TextField.nickName.inactiveTextColor
    )
}

extension WITextFieldType {
    enum TextField {
        case price
        case day
        case nickName
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .price, .day:
                return .numberPad
            case .nickName:
                return .default
            }
        }
        
        var textAlignment: NSTextAlignment {
            switch self {
            case .price, .day:
                return .right
            case .nickName:
                return .left
            }
        }
        
        var placeholder: String {
            switch self {
            case .price, .day:
                return "0"
            case .nickName:
                return "닉네임 입력"
            }
        }
        
        var label: String {
            switch self {
            case .price:
                return "원"
            case .day:
                return "일"
            case .nickName:
                return "(0/8)"
            }
        }
        
        var labelColor: UIColor {
            switch self {
            case .price, .day:
                return .winey_gray900
            case .nickName:
                return .winey_gray300
            }
        }
        
        var textLength: Int {
            switch self{
            case .price:
                return 11
            case .day:
                return 3
            case .nickName:
                return 8
            }
        }
        
        var textLeftPadding: CGFloat {
            switch self {
            case .price, .day:
                return 39
            case .nickName:
                return 18
            }
        }
        
        var textRightPadding: CGFloat {
            switch self {
            case .price, .day:
                return 39
            case .nickName:
                return 57
            }
        }
        
        var labelRightPadding: CGFloat {
            switch self {
            default:
                return 16
            }
        }
        
        var labelWidth: CGFloat {
            switch self {
            case .price, .day:
                return 16
            case .nickName:
                return 30
            }
        }
        
        var activeTextColor: UIColor {
            switch self {
            case .price, .day:
                return .winey_purple400
            case .nickName:
                return .winey_gray900
            }
        }
        
        var activeBorderColor: UIColor {
            switch self {
            case .price, .day:
                return .winey_purple400
            case .nickName:
                return .winey_gray900
            }
        }
        
        var inactiveTextColor: UIColor {
            switch self {
            case .price, .day:
                return .winey_purple400
            case .nickName:
                return .winey_gray500
            }
        }
    }
}

