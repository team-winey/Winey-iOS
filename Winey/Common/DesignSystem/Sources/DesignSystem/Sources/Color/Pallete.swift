//
//  Pallete.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/11.
//

import UIKit

enum Pallete: String {
    case mainYellow
    
    case blue500
    case green500
    case red500
    
    case purple100
    case purple200
    case purple300
    case purple400
    case purple500
    
    case gray0
    case gray50
    case gray100
    case gray200
    case gray300
    case gray400
    case gray500
    case gray600
    case gray700
    case gray800
    case gray900
}

extension UIColor {
    
    convenience init(pallete: Pallete) {
        self.init(named: pallete.rawValue, in: Bundle.module, compatibleWith: nil)!
    }
}
