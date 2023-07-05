//
//  FontLiterals.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit

extension UIFont {
    
    @nonobjc class var head_b28: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 28)
    }
    
    @nonobjc class var head_b24: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 24)
    }
    
    @nonobjc class var head_b20: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 20)
    }
    
    @nonobjc class var head_b18: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 18)
    }
    
    @nonobjc class var body_b16: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 16)
    }
    
    @nonobjc class var bodymain_m16: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    
    @nonobjc class var body2_b15: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 15)
    }
    
    @nonobjc class var body2_m15: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 15)
    }
    
    @nonobjc class var body3_b14: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 14)
    }
    
    @nonobjc class var body3_m14: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var detail_b13: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 13)
    }
    
    @nonobjc class var detail_m13: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 13)
    }
    
    @nonobjc class var detail_b12: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 12)
    }
    
    @nonobjc class var detail_m12: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 12)
    }

    @nonobjc class var detail_b11: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 11)
    }
    
    @nonobjc class var detail_m11: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 11)
    }
    
    @nonobjc class var detail_b10: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 10)
    }
    
    @nonobjc class var detail_m10: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 10)
    }

}

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardSemiBold = "Pretendard-SemiBold"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
