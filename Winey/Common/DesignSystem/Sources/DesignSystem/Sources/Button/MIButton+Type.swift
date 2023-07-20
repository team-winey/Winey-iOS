//
//  MIButton+Type.swift
//  
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

public struct MIButtonType {
    public let titleColor: UIColor
    public let backgroundColor: UIColor
    public let titleAttributes: Typography.Attributes
    public let disabledTitleColor: UIColor
    public let disabledBackgroundColor: UIColor
    
    public init(
        titleColor: UIColor,
        backgroundColor: UIColor,
        disabledTitleColor: UIColor,
        disabledBackgroundColor: UIColor,
        titleAttributes: Typography.Attributes
    ) {
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.disabledTitleColor = disabledTitleColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.titleAttributes = titleAttributes
    }
}

public extension MIButtonType {
    static let yellow: MIButtonType = MIButtonType(
        titleColor: .winey_gray900,
        backgroundColor: .winey_yellow,
        disabledTitleColor: .winey_gray500,
        disabledBackgroundColor: .winey_gray200,
        titleAttributes: .init(style: .body, weight: .medium, textColor: .winey_gray900)
    )
    static let gray: MIButtonType = MIButtonType(
        titleColor: .winey_gray500,
        backgroundColor: .winey_gray200,
        disabledTitleColor: .winey_gray500,
        disabledBackgroundColor: .winey_gray200,
        titleAttributes: .init(style: .body, weight: .medium, textColor: .winey_gray500)
    )
}
