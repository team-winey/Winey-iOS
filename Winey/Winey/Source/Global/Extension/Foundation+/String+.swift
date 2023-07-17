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
    
    var insertComma: String {
        let numberFormatter = NumberFormatter();
        numberFormatter.numberStyle = .decimal
        
        // 소수점이 있는 경우 처리
        if let _ = self.range(of: ".") {
            var numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
                
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        } else {
            guard let doubleValue = Double(self) else {
                return self
            }
            
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
}
