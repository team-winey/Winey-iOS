//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/17.
//

import UIKit

public struct WITextFieldType {
    public let textLeftPadding: CGFloat
    public let textRightPadding: CGFloat
    public let labelLeftPadding: CGFloat
    public let labelRightPadding: CGFloat
    public let textStyle: Typography.Attributes
    public let label: String
    public let labelStyle: Typography.Attributes
    
    public init(
        textLeftPadding: CGFloat,
        textRightPadding: CGFloat,
        labelLeftPadding: CGFloat,
        labelRightPadding: CGFloat,
        textStyle: Typography.Attributes,
        label: String,
        labelStyle: Typography.Attributes
    ) {
        self.textLeftPadding = textLeftPadding
        self.textRightPadding = textRightPadding
        self.labelLeftPadding = labelLeftPadding
        self.labelRightPadding = labelRightPadding
        self.textStyle = textStyle
        self.label = label
        self.labelStyle = labelStyle
    }
}

public extension WITextFieldType {
    static let upload_price: WITextFieldType = WITextFieldType(
        textLeftPadding: TextField.price.textLeftPadding,
        textRightPadding: TextField.price.textRightPadding,
        labelLeftPadding: TextField.price.labelLeftPadding,
        labelRightPadding: TextField.price.labelRightPadding,
        textStyle: Typography.Attributes(style: .headLine2,
                                         weight: .bold),
        label: TextField.price.label,
        labelStyle: Typography.Attributes(style: .headLine4,
                                          weight: .bold,
                                          textColor: UIColor.winey_gray900)
    )
    
    static let day: WITextFieldType = WITextFieldType(
        textLeftPadding: TextField.day.textLeftPadding,
        textRightPadding: TextField.day.textRightPadding,
        labelLeftPadding: TextField.day.labelLeftPadding,
        labelRightPadding: TextField.day.labelRightPadding,
        textStyle: Typography.Attributes(style: .headLine2,
                                         weight: .bold),
        label: TextField.day.label,
        labelStyle: Typography.Attributes(style: .headLine4,
                                          weight: .bold,
                                          textColor: UIColor.winey_gray900)
    )
    
    static let nickName: WITextFieldType = WITextFieldType(
        textLeftPadding: TextField.nickName.textLeftPadding,
        textRightPadding: TextField.nickName.textRightPadding,
        labelLeftPadding: TextField.nickName.labelLeftPadding,
        labelRightPadding: TextField.nickName.labelRightPadding,
        textStyle: Typography.Attributes(style: .headLine4,
                                         weight: .medium),
        label: TextField.nickName.label,
        labelStyle: Typography.Attributes(style: .body3,
                                          weight: .medium,
                                          textColor: UIColor.winey_gray300)
    )
}

extension WITextFieldType {
    enum TextField {
        case price
        case day
        case nickName
        
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
                return 40
            case .nickName:
                return 18
            }
        }
        
        var textRightPadding: CGFloat {
            switch self {
            case .price, .day:
                return 38
            case .nickName:
                return 57
            }
        }
        
        var labelLeftPadding: CGFloat {
            switch self {
            case .price, .day:
                return 4
            case .nickName:
                return 8
            }
        }
        
        var labelRightPadding: CGFloat {
            switch self {
            default:
                return 18
            }
        }
    }
}

