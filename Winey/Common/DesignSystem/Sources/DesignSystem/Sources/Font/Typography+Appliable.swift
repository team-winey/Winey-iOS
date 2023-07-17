//
//  Typography+Appliable.swift
//  DesignSystem
//
//  Created by Woody Lee on 2023/07/13.
//

import UIKit

public protocol TypographAppliable: AnyObject {
    var typography: NSAttributedString? { get set }
    
    func setText(_ string: String?, attributes: Typography.Attributes)
}

extension TypographAppliable {
    public func setText(_ string: String?, attributes: Typography.Attributes) {
        typography = Typography.build(string: string, attributes: attributes)
    }
}

extension UILabel: TypographAppliable {
    public var typography: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

extension UITextField: TypographAppliable {
    public var typography: NSAttributedString? {
        get { attributedText }
        set {
            attributedText = newValue
            self.textAlignment = .right
            self.attributedPlaceholder = newValue
        }
    }
}

extension UITextView: TypographAppliable {
    public var typography: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}
