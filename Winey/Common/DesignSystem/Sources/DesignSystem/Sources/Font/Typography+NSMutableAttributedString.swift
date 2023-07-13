//
//  Typography+NSMutableAttributedString.swift
//  DesignSystem
//
//  Created by Woody Lee on 2023/07/14.
//

import Foundation

extension NSMutableAttributedString {
    public func appending(
        string: String,
        attributes: Typography.Attributes
    ) -> NSMutableAttributedString {
        let newText = Typography.build(string: string, attributes: attributes)
        append(newText)
        return self
    }
    public func appending(
        _ attributedString: NSMutableAttributedString
    ) -> NSMutableAttributedString {
        append(attributedString)
        return self
    }
}
